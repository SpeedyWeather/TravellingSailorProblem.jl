using SpeedyWeather
using TravellingSailorProblem
using Documenter
using Printf
using Dates
using GLMakie

DocMeta.setdocmeta!(TravellingSailorProblem, :DocTestSetup, :(using TravellingSailorProblem); recursive=true)

# READ ALL SUBMISSIONS CODE
submissions = filter(x -> endswith(x, ".jl"), readdir(joinpath(@__DIR__, "../submissions")))
sort!(submissions)  # alphabetical order

function run_simulation(nchildren, layer, departures)
    spectral_grid = SpectralGrid(nparticles=nchildren, nlayers=8)
    particle_advection = ParticleAdvection2D(spectral_grid, layer=layer)
    model = PrimitiveWetModel(spectral_grid; particle_advection)
    simulation = initialize!(model, time=TravellingSailorProblem.DEFAULT_STARTDATE)

    # define children and add to the model as destinations
    children = TravellingSailorProblem.children(nchildren)
    add!(model, children)

    # define particle tracker and add to the model
    particle_tracker = ParticleTracker(spectral_grid)
    add!(model, :particle_tracker => particle_tracker)

    (; particles) = simulation.prognostic_variables
    for (i, d) in enumerate(departures)
        if i <= nchildren
            particles[i] = mod(Particle(d[1], d[2]))
        end
    end

    run!(simulation, period=TravellingSailorProblem.DEFAULT_PERIOD)
    return evaluate(particle_tracker, children), particle_tracker, children
end

# RUN SUBMISSIONS
function run_submission(path::String)
    include(path)
    evaluation, particle_tracker, children = run_simulation(nchildren, layer, departures)

    submission_dict = Dict(
        :author => name,
        :description => description,
        :nchildren => nchildren,
        :layer => layer,
        :evaluation => evaluation,
        :particle_tracker => particle_tracker,
        :children => children,
        :nreached => evaluation.nreached,
        :points => evaluation.total_points,
        :path => path,
        :code => read(path, String),
        :rank => 0,
    )
    return submission_dict
end

# dictionary of dictionaries to evaluate all submissions
all_submissions = Dict{String, Dict}()

# for sorting
nsubmissions = length(submissions)
all_points = zeros(nsubmissions)
all_names = Vector{String}(undef, nsubmissions)

for (i, submission) in enumerate(submissions)
    @info "Running submission $submission"
    name = split(submission, ".jl")[1]
    path = joinpath(@__DIR__, "..", "submissions", submission)
    all_submissions[name] = run_submission(path)
    all_points[i] = all_submissions[name][:points]
    all_names[i] = name
end

# sort submissions by points
sortargs = sortperm(all_points, rev=true)
all_names_ranked = all_names[sortargs]

for (i, name) in enumerate(all_names_ranked)
    all_submissions[name][:rank] = i
end

# GENERATE SUBMISSIONS LIST
@info "Building submissions.md"
open(joinpath(@__DIR__, "src/submissions.md"), "w") do mdfile
    header = read(joinpath(@__DIR__, "headers/submissions_header.md"), String)
    println(mdfile, header)

    # instead of sorting the dictionary, we iterate over the ranks
    for i in 1:nsubmissions
        # then find the submission with the given rank
        for (name, dict) in all_submissions
            rank = dict[:rank]
            if rank == i
                author = dict[:author]
                description = dict[:description]
                rank = dict[:rank]
                println(mdfile, "## $author: $description\n")
                println(mdfile, "path: `/submissions/$name.jl`\n")
                println(mdfile, "rank: $rank. of $nsubmissions submissions\n")
                
                # show code
                println(mdfile, "```julia")
                println(mdfile, dict[:code])
                println(mdfile, "```")
                println(mdfile, "Evaluation:")

                # visualise evaluation
                evaluation = dict[:evaluation]
                println(mdfile, "```julia")
                println(mdfile, evaluation)
                println(mdfile, "```")

                # generate globe
                particle_tracker = dict[:particle_tracker]
                children = dict[:children]
                evaluation = dict[:evaluation]
                MVP = argmax(evaluation.points)
                fig = globe(particle_tracker, children, perspective=children[MVP])
                name_without_spaces = replace(name, " " => "_")
                path = joinpath(@__DIR__, "src", "submission_$name_without_spaces.png")
                @info "Saving figure to $path"
                save(path, fig)
                println(mdfile, "![submission: $name](submission_$name_without_spaces.png)\n")
            end
        end
    end
end

# GENERATE LEADERBOARD
@info "Building leaderboard.md"
open(joinpath(@__DIR__, "src/leaderboard.md"), "w") do mdfile
    header = read(joinpath(@__DIR__, "headers/leaderboard_header.md"), String)
    println(mdfile, header)

    # instead of sorting the dictionary, we iterate over the ranks
    for i in 1:nsubmissions
        # then find the submission with the given rank
        for (name, dict) in all_submissions
            rank = dict[:rank]
            if rank == i
                # and write the submission as a line to the markdown file
                author = dict[:author]
                description = dict[:description]
                children = dict[:children]
                nchildren = dict[:nchildren]
                layer = dict[:layer]
                nreached = dict[:nreached]
                points = dict[:points]

                # most valuable player evaluation
                evaluation = dict[:evaluation]
                MVPi = argmax(evaluation.points)
                MVP_name = children[MVPi].name
                MVP_points = evaluation.points[MVPi] / (2π*SpeedyWeather.DEFAULT_RADIUS/1000)
                MVP = "$MVP_name ("*@sprintf("%.2f", MVP_points)*")"
                println(mdfile, "| $rank | $author | $description | $layer | $nreached/$nchildren | $MVP | $points |")
            end
        end
    end
end

makedocs(;
    modules=[TravellingSailorProblem],
    authors="Milan Klöwer <milankloewer@gmx.de> and contributors",
    sitename="TravellingSailorProblem.jl",
    format=Documenter.HTML(;
        canonical="https://speedyweather.github.io/TravellingSailorProblem.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "New to Julia?" => "new_to_julia.md",
        "Destination" => "destination.md",
        "Particle advection" => "particles.md",
        "Evaluation" => "evaluation.md",
        "TravellingSailorProblem challenge" => [
            "Instructions" => "instructions.md",
            "Submit" => "submit.md",
            "Leaderboard" => "leaderboard.md",
            "List of submissions" => "submissions.md",
        ],
        "Functions and types" => "functions_types.md",
    ],
)

deploydocs(
    repo="github.com/SpeedyWeather/TravellingSailorProblem.jl",
    devbranch="main",
    push_preview = true,
    versions = ["stable" => "v^", "v#.#.#", "dev" => "dev"],
)
