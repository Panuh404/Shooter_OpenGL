workspace "Quiet"
    architecture "x86_64"
    startproject "Quiet-Editor"

    configurations{
        "Debug",
        "Release",
        "Dist"
    }

    flags{
        "MultiProcessorCompile"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

--include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = 	"Engine/Vendor/GLFW/include"
IncludeDir["Glad"] = 	"Engine/Vendor/Glad/include"
IncludeDir["ImGui"] = 	"Engine/Vendor/ImGui"
IncludeDir["glm"] = 	"Engine/Vendor/glm"

--include vendor dependencies group
group "Dependencies"
    include "Engine/Vendor"
group ""

---------------------------------------------
--- ENGINE ----------------------------------
---------------------------------------------
project "Engine"
    location "Engine"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("Binaries/" .. outputdir .. "/%{prj.name}")
    objdir ("Intermediate/" .. outputdir .. "/%{prj.name}")

    files{
        "%{prj.name}/Source/**.h",
        "%{prj.name}/Source/**.cpp",
        "%{prj.name}/vendor/glm/glm/**.hpp",
        "%{prj.name}/vendor/glm/glm/**.inl"
    }

    defines{
        "_CRT_SECURE_NO_WARNINGS"
    }

    includedirs{
		"%{prj.name}/Source",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
	}

    links{
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    filter "system:windows"
        systemversion "latest"

        defines{
            "GLFW_INCLUDE_NONE"
        }

    filter "configurations:Debug"
        defines "QT_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "QT_RELEASE"
        runtime "Release"
        optimize "on"
