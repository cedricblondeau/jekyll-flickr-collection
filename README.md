# Jekyll Flickr Collection Plugin
Jekyll "generator" plug-in for embedding a Flickr collection (a set of specific photosets).
Example: http://tenmonthsaroundtheworld.cedricblondeau.com/

## Usage
Specify the Flickr collection ID and the Flickr user ID in your template.
The generator will inject an array of photosets as a template variable.

#### Example
```html
---
layout: default
flickr:
    collection_id: 72157651744154355
    user_id: 58782471@N05
---
{% if page.flickr.collection %}
	{% for set in page.flickr.collection %}
	<a href="{{ set.url }}" target="_blank" title="{{ set.title }}">
		<img src="{{ set.primary_photo_url }}" alt="{{ set.title }}" title="{{ set.title }}" />
	</a>
	{% endfor %}
{% endif %}
```

## Configuration
_config.yml:
```yaml
flickr:
  api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  shared_secret: xxxxxxxxxxxxxxxx
```

## Requirements

#### Apply for a Flickr API key
https://www.flickr.com/services/apps/create/apply/

#### FlickRaw
Flickraw is a library to access flickr api in a simple way.
```
gem install flickraw
```

## TODO
- Cache support

## Thanks!
- [Integrating Flickr and Jekyll](http://www.marran.com/tech/integrating-flickr-and-jekyll/)
