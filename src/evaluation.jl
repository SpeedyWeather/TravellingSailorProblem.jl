using NCDatasets
const DEFAULT_RADIUS = SpeedyWeather.DEFAULT_RADIUS

const POINTS_PER_KM_REACHED = 1     # points per km for reached destinations
const POINTS_PER_KM_MISSED = 10     # points per km for not reached destinations

mutable struct Evaluation
    ndestinations::Int
    nreached::Int
    total_points::Int
end

Base.show(io::IO, e::Evaluation) = print(io, "Evaluation: $(e.nreached)/$(e.ndestinations) reached, $(e.total_points) points")

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
    nsteps = size(lon, 2)
    NF = eltype(lon)

    total_points::Int = 0
    nreached::Int = 0
    
    for destination in destinations
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
            points = floor(Int, distance_flown/1e3*POINTS_PER_KM_REACHED)
            from_particle = i
        else
            # negative points for not reached destinations
            points = -floor(Int, destination.closest_distance/1e3*POINTS_PER_KM_MISSED)
            from_particle = destination.closest_particle
        end

        # sum up total points
        total_points += points
        name, lon_str, lat_str = destination_format(destination)
        pa_str = @sprintf("%2d", from_particle)
        po_str = @sprintf("%6d", points)
        reached_or_missed = destination.reached ? "reached by" : " missed by"
        println("Destination $name ($lon_str, $lat_str) $reached_or_missed particle $pa_str: $po_str points")
    end

    return Evaluation(length(destinations), nreached, round(Int,total_points))
end

