# Write in this file customization code that will get executed after all the
# soures have beenloaded.

# Uncomment to reenable building the RTT test suite
# This is disabled by default as it requires a lot of time and memory
#
# Autobuild::Package['rtt'].define "BUILD_TESTING", "ON"

# Package specific prefix:
# Autobuild::Package['rtt'].prefix='/opt/autoproj/2.0'
#
# See config.yml to set the prefix:/opt/autoproj/2.0 globally for all packages.

#build all as debug, if the build type is not already defined

#GENERAL SET TO USE C++11
#
#
Autobuild::Package.each do |name, pkg|
    if pkg.kind_of?(Autobuild::CMake)
        cxx_flags = "#{pkg.defines['CMAKE_CXX_FLAGS']} #{ENV['CXXFLAGS']}"
        if cxx_flags !~ /-std=c\+\+11/
            pkg.define "CMAKE_CXX_FLAGS", "#{cxx_flags} -std=c++11"
        end
    end
end

# SOLUTION USED IN SPACEBOT
#if Autoproj.respond_to?(:post_import)
#    # Override the CMAKE_BUILD_TYPE if no tag is set
#    Autoproj.post_import do |pkg|
#        next if !pkg.kind_of?(Autobuild::CMake)
#
#        pkg.define "ROCK_USE_CXX11", "TRUE"
#
#        if !pkg.defines.has_key?('CMAKE_BUILD_TYPE')
#            if(pkg.tags.empty?)
#                 pkg.define "CMAKE_BUILD_TYPE", "RelWithDebInfo"
#            end
#        else
#            if(pkg.defines["CMAKE_BUILD_TYPE"] == 'Debug' && pkg.tags.empty?)
#                 pkg.define "CMAKE_BUILD_TYPE", "RelWithDebInfo"
#            end
#       end
#    end
#end



Autoproj.env_set 'ORBgiopMaxMsgSize', 16000000
