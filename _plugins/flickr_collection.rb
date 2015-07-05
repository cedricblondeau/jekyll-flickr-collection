# Flickr Collection Generator Plugin
#
# Author: Cedric Blondeau
# Site: http://www.cedricblondeau.com
# Source: https://github.com/cedricblondeau/jekyll-flickr-collection

require 'flickraw'

module Jekyll

  class FlickrCollectionGenerator < Generator

    priority :low

    def generate(site)
      # Looking for a page with a flickr collection ID
      page = site.pages.detect {|page| page.data['flickr'] && page.data['flickr']['collection_id']}

      if page
        # Getting config data from the page
        collection_id = page.data['flickr']['collection_id']
        user_id = page.data['flickr']['user_id']

        # Passing the collection to the page
        page.data['flickr']['collection'] = get_collection(site, collection_id, user_id)
      end
    end

    def get_collection(site, collection_id, user_id)
      # Getting collection tree through Flickr API
      FlickRaw.api_key = site.config['flickr']['api_key']
      FlickRaw.shared_secret = site.config['flickr']['shared_secret']
      apiCollectionTree = flickr.collections.getTree :collection_id => collection_id, :user_id => user_id

      # Build an array with FlickrSet objects
      collection = Array.new
      apiCollectionTree.collection[0].set.each_index do | i |
        # Get photoset info (we need this to generate the primary photo url)
        id = apiCollectionTree.collection[0].set[i].id
        apiPhotosetInfo = flickr.photosets.getInfo :photoset_id => id

        # Build a FlickrSet object
        title = apiCollectionTree.collection[0].set[i].title
        url = FlickRaw.url_photoset(apiPhotosetInfo)
        primaryPhotoUrl = FlickrUrl.url_photoset_primary_photo(apiPhotosetInfo)
        set = FlickrSet.new(title, url, primaryPhotoUrl)

        # Push FlickrSet object to array
        collection.push(set)
      end
      collection
    end

  end

  class FlickrSet
    attr_accessor :title, :url, :primaryPhotoUrl

    def initialize(title, url, primaryPhotoUrl)
      @title = title
      @url = url
      @primaryPhotoUrl = primaryPhotoUrl
    end

    def to_liquid
      {
          'title' => title,
          'url' => url,
          'primary_photo_url' => primaryPhotoUrl
      }
    end
  end

  class FlickrUrl
    def self.url_photoset_primary_photo(r); FlickRaw::PHOTO_SOURCE_URL % [r.farm, r.server, r.primary, r.secret, "_z", "jpg"] end
  end

end
