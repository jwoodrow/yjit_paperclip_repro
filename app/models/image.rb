class Image < ApplicationRecord
  has_attached_file :attachment,
                    styles:     {
                      thumb: {
                        geometry:        '725x1200>',
                        format:          'jpg',
                        convert_options: '-auto-orient -flatten -density 300 -quality 75'
                      }
                    },
                    processors: %i[thumbnail],
                    path:       'images/:id_partition/:style/:filename'
  
  validates_attachment_file_name :attachment, matches: /(\.png)|(\.jpe?g)$/
  validates_attachment :attachment, presence: true, size: { less_than: 20.megabytes }

  def attachment=(new_attachment)
    attachment.assign(new_attachment)
    @attachment = new_attachment
  end
end
