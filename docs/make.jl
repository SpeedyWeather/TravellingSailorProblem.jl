using SpeedyWeather
using TravellingSailorProblem
using Documenter
using Printf
using Dates

DocMeta.setdocmeta!(TravellingSailorProblem, :DocTestSetup, :(using TravellingSailorProblem); recursive=true)

# READ ALL SUBMISSIONS CODE
submissions = filter(x -> endswith(x, ".jl"), readdir(joinpath(@__DIR__, "../submissions")))
sort!(submissions)  # alphabetical order

# RUN SUBMISSIONS
function run_submission(path::String)
    include(path)

    submission_dict = Dict(
        "author" => name,
        "description" => description,
        "nchildren" => nchildren,
        "layer" => layer,
        "reached" => 0,
        "points" => 0,
        "path" => path,
        "code" => read(path, String),
        "rank" => 0,
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
    all_points[i] = all_submissions[name]["points"]
    all_names[i] = name
end

# sort submissions by points
sortargs = sortperm(all_points, rev=true)
all_names_ranked = all_names[sortargs]

for (i, name) in enumerate(all_names_ranked)
    all_submissions[name]["rank"] = i
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
            rank = dict["rank"]
            if rank == i
                author = dict["author"]
                description = dict["description"]
                rank = dict["rank"]
                println(mdfile, "## $author: $description\n")
                println(mdfile, "path: `/submissions/$name.jl`\n")
                println(mdfile, "rank: $rank. of $nsubmissions submissions\n")
                println(mdfile, "```@example $name")
                # println(mdfile, "using CairoMakie # hide")
                println(mdfile, dict["code"])

                # # translate SKIP_START::Period const to string
                # period_str = string(typeof(SKIP_START))*"($(SKIP_START.value))"

                # println(mdfile, "RainMaker.plot(rain_gauge, skip=$period_str) # hide")
                # println(mdfile, """save("submission_$name.png", ans) # hide""")
                println(mdfile, "nothing # hide")
                println(mdfile, "```")
                # println(mdfile, "![submission: $name](submission_$name.png)\n")
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
            rank = dict["rank"]
            if rank == i
                # and write the submission as a line to the markdown file
                author = dict["author"]
                description = dict["description"]
                children = dict["nchildren"]
                layer = dict["layer"]
                reached = dict["reached"]
                points = dict["points"]
                println(mdfile, "| $rank | $author | $description | $layer | $reached/$children | $points |")
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
    ],
)

deploydocs(
    repo="github.com/SpeedyWeather/TravellingSailorProblem.jl",
    devbranch="main",
    push_preview = true,
    versions = ["stable" => "v^", "v#.#.#", "dev" => "dev"],
)
