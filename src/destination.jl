const DESTINATION_RADIUS = 100_000 # in meters

export Destination

@kwdef mutable struct Destination{NF} <: SpeedyWeather.AbstractCallback
    lonlat::NTuple{2, NF} = rand(CITIES)
    name::Symbol = rand(NAMES)
    radius::NF = DESTINATION_RADIUS
    reached::Bool = false
    particle::Int = 0
    closest::NF = Inf
    distance::NF = 0
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

		distance = spherical_distance((p.lon, p.lat), destination.lonlat, radius=model.planet.radius)
		destination.closest = min(destination.closest, distance)

		if !destination.reached && distance <= destination.radius
			destination.reached = true
			s1 = "Destination $(destination.name) at $(destination.lonlat[2])˚N, $(destination.lonlat[1])˚E"
			s2 = " reached by particle $i on $(progn.clock.time)"
			@info s1*s2
			progn.particles[i] = deactivate(p)
		end
	end
end

SpeedyWeather.finalize!(::Destination, args...) = nothing

const NCHILDREN = 10
const NF = Float32

const Children = [Destination{NF}(lonlat=CITIES[i], name=NAMES[i]) for i in 1:NCHILDREN]