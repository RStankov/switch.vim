require 'tmpdir'
require 'vimrunner'
require_relative './support/vim'

RSpec.configure do |config|
  config.include Support::Vim

  config.before(:suite) do
    VIM = Vimrunner.start_gvim
    VIM.add_plugin(File.expand_path('.'), 'plugin/switch.vim')

    def VIM.switch
      command 'Switch'
      write
      self
    end
  end

  config.after(:suite) do
    VIM.kill
  end

  # cd into a temporary directory for every example.
  config.around do |example|
    @vim = VIM

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        @vim.command("cd #{dir}")
        example.call
      end
    end
  end
end
