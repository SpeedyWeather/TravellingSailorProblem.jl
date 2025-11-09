using GeoMakie, FileIO
import Proj, GeometryOps, GeoInterface, GeoFormatTypes

const ASSETS_PATH = joinpath(dirname(@__DIR__), "assets")
mkpath(ASSETS_PATH)  # create assets directory if it doesn't exist

if !isfile(joinpath(ASSETS_PATH, "bluemarble.png"))
    # @info "Downloading bluemarble background image."
    download("https://eoimages.gsfc.nasa.gov/images/imagerecords/74000/74493/world.topo.200411.3x5400x2700.jpg", joinpath(ASSETS_PATH, "bluemarble.png"))
end

function bad_spherical_cap(point, radius; npoints = 100)
    points = [radius .* reverse(sincos(t)) for t in LinRange(0, 2pi, npoints)]
    poly = GeoInterface.Polygon([GeoInterface.LinearRing(points)])
    return GeometryOps.reproject(
        poly;
        source_crs = GeoFormatTypes.ProjString("+proj=ortho +lon_0=$(GeoInterface.x(point)) +lat_0=$(GeoInterface.y(point))"),
        target_crs = GeoFormatTypes.EPSG(4326)
    )
end

export globe

"""$(TYPEDSIGNATURES)
Make `destinations` and `particle_tracker` arguments commutative by calling the main implementation with swapped argument order."""
function SpeedyWeather.globe(
    particle_tracker::SpeedyWeather.ParticleTracker,
    destinations::Union{Nothing, NTuple{N, <:Destination}} = nothing;
    kwargs...,
) where N 
    SpeedyWeather.globe(destinations, particle_tracker; kwargs...)
end

"""$(TYPEDSIGNATURES)

Create a 3D interactive or static globe visualization of particle tracks and destinations.

Displays a spherical Earth background with particle trajectories and destination markers. 
Destinations are shown as hexagons (unreached) or filled (reached), with the first letter as a marker.
Particle tracks are drawn as 3D lines with optional shadows and track endpoints.

# Arguments
- `destinations::NTuple{N, <:Destination}`: Tuple of destination objects to display
- `particle_tracker::Union{Nothing, ParticleTracker}`: Optional particle trajectory data from NetCDF file
- `background::Bool`: Show Earth background image (default: true)
- `coastlines::Bool`: Draw coastlines (default: true)
- `interactive::Bool`: Enable interactive 3D globe (GlobeAxis) or static orthographic view (default: true)
- `shadows::Bool`: Draw ground shadows for tracks and destinations (default: true)
- `track_labels::Bool`: Show particle endpoint markers and numbers (default: true)
- `track_numbers::Bool`: Display particle numbers at endpoints (default: true)
- `legend::Bool`: Show legend with reached/missed status (default: true)
- `altitude_tracks`: Altitude offset for particle tracks in meters (default: 200000)
- `altitude_destinations`: Altitude offset for destination markers in meters (default: 200000)
- `perspective`: View center as (lon, lat) tuple or Destination object (default: (0, 0))
- `altitude`: Camera altitude for interactive view in meters (default: 1.2e7)
- `size::Tuple`: Figure size as (width, height) in pixels (default: (500, 500))
- `return_figure::Bool`: Return figure object instead of displaying (default: false)

# Returns
- `Figure` if `return_figure=true`, otherwise displays the figure and returns nothing
"""
function SpeedyWeather.globe(
    destinations::Union{Nothing, NTuple{N, <:Destination}}=nothing,
    particle_tracker::Union{Nothing, SpeedyWeather.ParticleTracker}=nothing;
    background::Bool = true,
    coastlines::Bool = true,
    shadows::Bool = true,
    track_labels::Bool = true,
    track_numbers::Bool = true,
    legend::Bool = true,
    altitude_destinations = 200_000,
    altitude_tracks = altitude_destinations*0.8,
    altitude_shadows = altitude_tracks/10,
    perspective = (30, 30),
    altitude = 1.2e7,
    size = (800, 800),
    greyscale_transform = x -> 0.4*x + 0.2
) where N

    perspective = perspective isa Destination ? perspective.lonlat : perspective

    Makie.set_theme!(Attributes(; palette = (; color = Makie.to_colormap(:tab20), patchcolor = Makie.to_colormap(:tab20))))

    fig = Figure(size=size);
    ax = GlobeAxis(fig[1, 1]; show_axis = false, camera_longlat=perspective, camera_altitude=altitude)

    # background image
    if background
        earth = isfile(joinpath(ASSETS_PATH, "bluemarble.png")) ? load(joinpath(ASSETS_PATH, "bluemarble.png")) : GeoMakie.earth()
        grey_earth = greyscale_transform.(rotr90(Gray.(earth)))
        meshimage!(ax, -180..180, -90..90, grey_earth; npoints = 100)
    end

    # coastlines
    if coastlines
        lines!(ax, GeoMakie.coastlines(50); color=:white, linewidth=0.2)
    end

    # visualise tracks
    if !isnothing(particle_tracker)
        ds = NCDataset(joinpath(particle_tracker.path, particle_tracker.filename))
        plon = ds["lon"][:, :]
        plat = ds["lat"][:, :]
        pz = altitude_tracks .+ zero(plon)
        pzs = altitude_shadows .+ zero(plon)
        particles = ds["particle"][:]
        close(ds)

        for i in eachindex(particles)
            lines!(ax, plon[i, :], plat[i, :], pz[i, :], color=Cycled(i), linewidth=2)
            shadows && lines!(ax, plon[i, :], plat[i, :], pzs[i, :], color=:black, alpha=0.5, linewidth=2)
            if track_labels && (length(particles) < 100)
                scatter!(ax, plon[i, end], plat[i, end], pz[i, end] * 1.05; color=:black, marker=:circle, markersize=22)
                
                if shadows
                    circle = bad_spherical_cap(Point2f(plon[i, end], plat[i, end]), 50_000)
                    poly!(ax, circle, color=:black, alpha=0.5, zlevel=altitude_shadows)
                end

                scatter!(ax, plon[i, end], plat[i, end], pz[i, end] * 1.05; color=:white, marker=:circle, markersize=20)
                track_numbers && text!(ax, plon[i, end], plat[i, end], pz[i, end]*  1.05; color=:black, text=string(i), fontsize=10, align=(:center, :center))
            end
        end

        # dummy scatter for legend
        scatter!(ax, 0, 0, -1e6; marker='1', color=:black, markersize=14, label="particle")
    end

    if !isnothing(destinations)
        # visualise destinations
        lons = [d.lonlat[1] for d in destinations]
        lats = [d.lonlat[2] for d in destinations]
        radii = [d.radius for d in destinations]
        z = fill(altitude_destinations, length(lons))

        colors = [d.reached ? 0 : 1 for d in destinations]
        colors2 = [d.reached ? 1 : 0 for d in destinations]
        markers = [only(string(d.name)[1]) for d in destinations]
        scatter!(ax, lons, lats, z; marker=:hexagon, color=:black, markersize=22)
        scatter!(ax, lons, lats, z; marker=:hexagon, color=colors,
            colorrange=(0, 1), markersize=20)
        scatter!(ax, lons, lats, z; marker=markers, color=colors2, colorrange=(0, 1), markersize=10)

        if shadows
            circles = [bad_spherical_cap(Point2f(lon, lat), radius) for (lon, lat, radius) in zip(lons, lats, radii)]
            poly!(ax, circles, color=colors, colorrange=(0,1), alpha=0.3, zlevel=10_000)
        end

        scatter!(ax, 0, 0, -1e6; marker=:hexagon, color=0, colorrange=(0, 1), markersize=16, label="reached")
        scatter!(ax, 0, 0, -1e6; marker=:hexagon, color=1, colorrange=(0, 1), markersize=16, label="missed")
    end

    if !isnothing(particle_tracker) || !isnothing(destinations)
        legend && axislegend(ax, position=:lb)
    end

    return fig
end