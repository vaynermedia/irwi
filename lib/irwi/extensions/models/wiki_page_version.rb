module Irwi::Extensions::Models::WikiPageVersion
  
  module ClassMethods
        
  end
  
  module InstanceMethods    
    
    def next
      self.class.first :conditions => ["id > ? AND page_id = ?", id, page_id], :order => 'id ASC'
    end
  
    def previous
      self.class.first :conditions => ["id < ? AND page_id = ?", id, page_id], :order => 'id DESC'
    end
    
    protected
    
    def raise_on_update
      raise ActiveRecordError.new "Cann't modify existent version"
    end
    
  end
  
  def self.included( base )
    base.send :extend, Irwi::Extensions::Models::WikiPageVersion::ClassMethods
    base.send :include, Irwi::Extensions::Models::WikiPageVersion::InstanceMethods
    
    base.belongs_to :page, :class_name => Irwi.config.page_class_name
    base.belongs_to :updator, :class_name => Irwi.config.user_class_name
    
    base.before_update :raise_on_update
  end
  
end