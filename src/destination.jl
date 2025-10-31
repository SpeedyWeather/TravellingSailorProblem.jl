"""
    DESTINATION_RADIUS = 100_000

The default radius (in meters) around a destination that a particle must reach to be 
considered as having arrived at the destination.
"""
const DESTINATION_RADIUS = 100_000 # in meters

export Destination

"""
    Destination{NF} <: SpeedyWeather.AbstractCallback

A callback structure representing a geographical destination that particles can reach.
Tracks when particles arrive within a specified radius of the destination. Fields are $(TYPEDFIELDS)"""
@kwdef mutable struct Destination{NF} <: SpeedyWeather.AbstractCallback
    "[OPTION] Longitude and latitude coordinates of the destination"
    lonlat::NTuple{2, NF} = rand(PLACES)

    "[OPTION] Name of the destination"
    name::Symbol = rand(NAMES)

    "[OPTION] Radius (in meters) around the destination for arrival detection"
    radius::NF = DESTINATION_RADIUS

    "[OPTION] Whether to print messages when destination is reached"
	verbose::Bool = isinteractive()
	
    "[DERIVED] Flag indicating whether the destination has been reached"
    reached::Bool = false

    "[DERIVED] Index of the particle that reached the destination"
    particle::Int = 0

    "[DERIVED] Minimum distance from any particle to the destination"
    closest_distance::NF = Inf

    "[DERIVED] Index of the particle currently closest to the destination"
	closest_particle::Int = 0

	"[DERIVED] Points given for this destination (computed during evaluation)"
	points::Int = 0
end

"""$(TYPEDSIGNATURES)
Constructor for creating a Destination with a specific number format (NF) from a SpectralGrid."""
Destination(SG::SpectralGrid; kwargs...) = Destination{SG.NF}(; kwargs...)
SpeedyWeather.initialize!(d::Destination, args...) = SpeedyWeather.callback!(d, args...)

"""$(TYPEDSIGNATURES)
Main callback function that checks if any particle has reached the destination.
Tracks closest particle and deactivates it when reaching the destination."""
function SpeedyWeather.callback!(
	destination::Destination,
	progn::PrognosticVariables,
	diagn::DiagnosticVariables,
	model::AbstractModel,
)
	destination.reached && return nothing

	for (i, p) in enumerate(progn.particles)

		if !destination.reached
			distance = spherical_distance((p.lon, p.lat), destination.lonlat, radius=model.planet.radius)
		
			if distance < destination.closest_distance
				destination.closest_distance = distance
				destination.closest_particle = i
			end
			
			if distance <= destination.radius
				destination.reached = true
				destination.particle = i
				progn.particles[i] = deactivate(p)
				if destination.verbose
					println()
					s1 = "Destination $(destination.name) at $(destination.lonlat[2])˚N, $(destination.lonlat[1])˚E"
					s2 = " reached by particle $i on $(progn.clock.time)"
					@info s1*s2
				end
			end
		end
	end
end

SpeedyWeather.finalize!(::Destination, args...) = nothing

"""$(TYPEDSIGNATURES)
Unpack a tuple of destinations and add each one individually to the target."""
SpeedyWeather.add!(to, destinations::NTuple{N, <:Destination}) where N = 
	add!(to, destinations...)

"""$(TYPEDSIGNATURES)
Add one or more destinations as callbacks to a model."""
SpeedyWeather.add!(model::AbstractModel, destinations::Destination...) = 
	add!(model.callbacks, destinations...)

"""$(TYPEDSIGNATURES)
Add one or more destinations to the callbacks dictionary using their name as the key."""
SpeedyWeather.add!(callbacks::SpeedyWeather.CALLBACK_DICT, destinations::Destination...) = 
	add!(callbacks, ((d.name => d) for d in destinations)...)

"""$(TYPEDSIGNATURES)
Format a destination's information for display as `(name, lon, lat)` strings."""
function destination_format(d::Destination)
	fmt = Printf.Format("%$(MAX_NAME_LENGTH)s")
	name = Printf.format(fmt, string(d.name))
	lon = @sprintf("%6.1f˚E", d.lonlat[1])
	lat = @sprintf("%5.1f˚N", d.lonlat[2])
	return name, lon, lat
end

"""$(TYPEDSIGNATURES)
Generate a compact string representation of a destination."""
function shortstring(d::Destination)
	name, lon, lat = destination_format(d)
	r = @sprintf("%6s", d.reached)
	return "Destination($name, $lon, $lat, reached=$r)"
end

"""$(TYPEDSIGNATURES)
Pretty-print a tuple of destinations on separate lines."""
Base.show(io::IO, ds::NTuple{N, <:Destination}) where N = join(io, shortstring.(ds), "\n")
Base.show(io::IO, ds::Tuple{}) = print(io, "()")

"""
    NCHILDREN = 10

The default number of destinations/particles to create when using the `children()` function.
"""
const NCHILDREN = 10

"""
    NF = Float32

The default numeric type (Float32) for destination coordinates.
"""
const NF = Float32

"""$(TYPEDSIGNATURES)
Create a tuple of n destinations with predefined locations and names from PLACES and NAMES."""
function children(n=NCHILDREN, ::Type{T}=NF; kwargs...) where T
	return Tuple(Destination{T}(lonlat=PLACES[i], name=NAMES[i]; kwargs...) for i in 1:n)
end

Base.isless(d1::Destination, d2::Destination) = d1.points < d2.points

# convert a tuple of destinations to a sorted tuple via copy to vector
function Base.sort(ds::NTuple{N, <:Destination}) where N
	ds_sorted = sort([ds...])
	return ntuple(d -> ds_sorted[d], N)
end