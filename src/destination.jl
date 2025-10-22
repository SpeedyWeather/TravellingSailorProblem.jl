const DESTINATION_RADIUS = 100_000 # in meters

export Destination

@kwdef mutable struct Destination{NF} <: SpeedyWeather.AbstractCallback
    lonlat::NTuple{2, NF} = rand(PLACES)
    name::Symbol = rand(NAMES)
    radius::NF = DESTINATION_RADIUS
    reached::Bool = false
    particle::Int = 0
    closest_distance::NF = Inf
	closest_particle::Int = 0
	verbose::Bool = isinteractive()
end

Destination(SG::SpectralGrid; kwargs...) = Destination{SG.NF}(; kwargs...)

SpeedyWeather.initialize!(d::Destination, args...) = SpeedyWeather.callback!(d, args...)

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

# unpack tuple
SpeedyWeather.add!(to, destinations::NTuple{N, <:Destination}) where N = 
	add!(to, destinations...)

# use destination name as key
SpeedyWeather.add!(model::AbstractModel, destinations::Destination...) = 
	add!(model.callbacks, destinations...)
SpeedyWeather.add!(callbacks::SpeedyWeather.CALLBACK_DICT, destinations::Destination...) = 
	add!(callbacks, ((d.name => d) for d in destinations)...)


function destination_format(d::Destination)
	fmt = Printf.Format("%$(MAX_NAME_LENGTH)s")
	name = Printf.format(fmt, string(d.name))
	lon = @sprintf("%6.1f˚E", d.lonlat[1])
	lat = @sprintf("%5.1f˚N", d.lonlat[2])
	return name, lon, lat
end

function shortstring(d::Destination)
	name, lon, lat = destination_format(d)
	return "Destination($name, $lon, $lat, reached=$(d.reached))"
end

function Base.show(io::IO, ds::NTuple{N, <:Destination}) where N 
	for d in ds[1:end-1]
		println(io, shortstring(d))
	end
	print(io, shortstring(ds[end]))
end

const NCHILDREN = 10
const NF = Float32

function children(n=NCHILDREN, ::Type{T}=NF; kwargs...) where T
	return Tuple(Destination{T}(lonlat=PLACES[i], name=NAMES[i]; kwargs...) for i in 1:n)
end