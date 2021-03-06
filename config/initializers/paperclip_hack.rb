# There's an outstanding bug with Paperclip on JRuby where you'll
# get a permissions error when trying to FileUtils.mv a file
# from the tmp directory to the configured storage location.
# This is an ugly, nasty hack to replace that call with
# FileUtils.cp followed by FileUtils.rm
# See:
#  http://github.com/thoughtbot/paperclip/issues/issue/12
#  http://github.com/thoughtbot/paperclip/issues/issue/193
#  http://dev.nuclearrooster.com/2009/03/03/errnoeacces-permissions-error-using-paperclip/
module Paperclip
  module Storage
    module Filesystem
      def flush_writes
        @queued_for_write.each do |style_name, file|
          file.close
          FileUtils.mkdir_p(File.dirname(path(style_name)))
          log("saving #{path(style_name)}")
          FileUtils.cp(file.path, path(style_name))
          FileUtils.rm(file.path)
          FileUtils.chmod(0644, path(style_name))
        end
        @queued_for_write = {}
      end
    end
  end
end
