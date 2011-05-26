module Interpres
  module GoogleDocs
    module ListDataApi
      
      ## http://code.google.com/intl/es-ES/apis/documents/docs/3.0/reference.html#Visibility
      ## http://code.google.com/intl/es-ES/apis/documents/docs/3.0/reference.html#Documents_List_Feed
      ## http://code.google.com/intl/es-ES/apis/documents/docs/3.0/reference.html#DocumentsFoldersFeed
      DOCUMENTS_LIST_FEED = "https://docs.google.com/feeds/documents/private/full/[resourceID]"
      FOLDERS_LIST_FEED   = "https://docs.google.com/feeds/default/private/full/[resourceID]/contents"
    
      ## http://code.google.com/intl/es-ES/apis/documents/docs/3.0/reference.html#ExportParameters
      # docID         Required. Specifies the document/presentation id to download.
      # exportFormat  Optional. Specifies the output format.
      #               Values    txt
      #                         odt
      #                         pdf
      #                         html
      #                         rtf
      #                         doc
      #                         png
      #                         zip
      DOCUMENTS_LIST_EXPORT = "https://docs.google.com/feeds/download/documents/Export?docID=[docID]&exportFormat=[exportFormat]"
      
      
    
    end
  end
end