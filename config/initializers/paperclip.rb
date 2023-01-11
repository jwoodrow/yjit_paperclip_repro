Paperclip::Attachment.class_eval do
    def assign(uploaded_file)
      @file = Paperclip.io_adapters.for(uploaded_file, options[:adapter_options])
  
      ensure_required_accessors!
      ensure_required_validations!
  
      return unless @file.assignment?
  
      clear(*only_process)
  
      return unless @file.present?
  
      assign_attributes
      convert_heic_to_well_known_image
      post_process_file
      reset_file_if_original_reprocessed
    end
  
    private
  
      def convert_heic_to_well_known_image
        return unless ['image/heic', 'image/heif'].include?(@file.content_type)
  
        style = Paperclip::Style.new(:original_jpeg, ['', :jpg], self)
        post_process_style(:original, style)
        reset_file_if_original_reprocessed
        basename = File.basename(@file.original_filename, '.*')
        instance_write(:file_name, "#{basename}.jpg")
        instance_write(:content_type, 'image/jpeg')
      end
  end