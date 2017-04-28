module Uploadable
  extend ActiveSupport::Concern

  included do
    before :store, :remember_cache_id
    after :store, :delete_tmp_dir
    after :remove, :delete_empty_upstream_dirs

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def cache_dir
      "/tmp/#{mounted_as}_uploads"
    end

    # store! nil's the cache_id after it finishes so we need to remember it for deletion
    def remember_cache_id(new_file)
      @cache_id_was = cache_id
    end

    def delete_tmp_dir(new_file)
      # make sure we don't delete other things accidentally by checking the name pattern
      if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
        FileUtils.rm_rf(File.join(root, cache_dir, @cache_id_was))
      end
    end

    def delete_empty_upstream_dirs
      path = ::File.expand_path(store_dir, root)
      Dir.delete(path)
    rescue SystemCallError
      true
    end
  end
end
