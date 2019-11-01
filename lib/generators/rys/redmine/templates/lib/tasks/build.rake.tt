namespace :easybundler do
  desc 'Copy gems into plugins/easysoftware/gems'
  task :build do
    require_relative '../../easybundler/build_deployment'
    Easybundler::BuildDeployment.run!
  end

  desc 'Link gems into plugins/easysoftware/local'
  task :build_local do
    require_relative '../../easybundler/build_local'
    Easybundler::BuildLocal.run!
  end

  desc 'Revert gems from plugins/easysoftware/gems'
  task :revert do
    require_relative '../../easybundler/build_deployment'
    Easybundler::BuildDeployment.run!(revert: true)
  end

  desc 'Revert gems from plugins/easysoftware/local'
  task :revert_local do
    require_relative '../../easybundler/build_local'
    Easybundler::BuildLocal.run!(revert: true)
  end
end
