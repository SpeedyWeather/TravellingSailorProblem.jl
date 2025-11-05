using NCDatasets
const DEFAULT_RADIUS = SpeedyWeather.DEFAULT_RADIUS

const POINTS_PER_KM_REACHED = 1     # points per km for reached destinations
const POINTS_PER_KM_MISSED = -10    # points per km for not reached destinations
const DEFAULT_STARTDATE = DateTime(2025, 11, 13)
const DEFAULT_PERIOD = Day(41)

mutable struct Evaluation
    ndestinations::Int
    nreached::Int
    total_points::Int
    points::Vector{Int}
    io::String
end

function Base.show(io::IO, e::Evaluation)
    ds = split(e.io, '\n')
    for d in ds
        color = occursin("reached", d) ? :light_yellow : :light_blue
        printstyled(io, d*"\n"; color)
    end
    print(io, "Evaluation: $(e.nreached)/$(e.ndestinations) reached, $(e.total_points) points")
end

export evaluate

# unpack tuple
evaluate(p, destinations::NTuple{N, <:Destination}) where N = evaluate(p, destinations...)

# make commutative
evaluate(destinations::NTuple{N, <:Destination}, p::SpeedyWeather.ParticleTracker) where N = evaluate(p, destinations)

function evaluate(
    particle_tracker::SpeedyWeather.ParticleTracker,
    destinations::Destination...;
    radius=DEFAULT_RADIUS)

    # load particle tracks
    ds = NCDataset(joinpath(particle_tracker.path, particle_tracker.filename))
    lon = ds["lon"][:, :]
    lat = ds["lat"][:, :]
    close(ds)
    nsteps = size(lon, 2)
    NF = eltype(lon)

    total_points::Int = 0
    nreached::Int = 0
    points = zeros(length(destinations))
    io = IOBuffer()
    
    for (j, destination) in enumerate(destinations)
        if destination.reached
            nreached += 1
            i = destination.particle

            distance_flown::NF = 0                      # in meters
            for t in 2:nsteps
                distance_flown += spherical_distance(
                    (lon[i, t-1], lat[i, t-1]),         # previous location
                    (lon[i, t], lat[i, t]);             # current location
                    radius=radius)
            end

            # positive points for reached destinations
            points[j] = floor(Int, distance_flown/1e3*POINTS_PER_KM_REACHED)
            from_particle = i
        else
            # negative points for not reached destinations
            points[j] = floor(Int, destination.closest_distance/1e3*POINTS_PER_KM_MISSED)
            from_particle = destination.closest_particle
        end

        destination.points = points[j]
        name, lon_str, lat_str = destination_format(destination)
        pa_str = @sprintf("%2d", from_particle)
        po_str = @sprintf("%6d", points[j])
        reached_or_missed = destination.reached ? "reached by" : " missed by"
        color = destination.reached ? :light_yellow : :light_blue
        dj = @sprintf("%2d", j)

        s = "Destination $dj $name ($lon_str, $lat_str)"*
            " $reached_or_missed particle $pa_str: $po_str points\n"

        printstyled(io, s; color)
    end
    
    points_int = round.(Int, points)
    total_points = sum(points_int)
    s = String(take!(io))
    return Evaluation(length(destinations), nreached, total_points, points_int, s)
end

export run_submission
function run_submission(;
    nchildren,
    layer,
    departures
)
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
    return particle_tracker, children
end