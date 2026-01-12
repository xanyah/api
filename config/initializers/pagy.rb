# frozen_string_literal: true

# Pagy initializer file (43.2.0)
# Customize only what you really need and notice that the core Pagy works also without any of the following lines.

# Pagy Options
# See https://ddnexus.github.io/pagy/docs/api/pagy#options
# You can set any pagy option. They can also be overridden per instance by just passing them to
# Pagy.new|Pagy::Countless.new|Pagy::Calendar::*.new or any of the #pagy* controller methods
# Here are the few that make more sense as options:
Pagy.options[:limit] = 100 # default: 20
# Pagy.options[:size]        = 7                     # default
# Pagy.options[:end]         = true                  # default (was :ends in previous versions)
# Pagy.options[:page_key]    = 'page'                # default (was :page_param as symbol in previous versions)
# Pagy.options[:max_pages]   = 3000                  # example

# Headers: http response headers (and other helpers) useful for API pagination
# Previously required 'pagy/extras/headers', now integrated into core
# Pagy.options[:headers] = { page: 'Current-Page',
#                            limit: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# Rails
# Enable the .js file required by the helpers that use javascript
# (pagy*_nav_js, pagy*_combo_nav_js, and pagy_limit_selector_js)
# See https://ddnexus.github.io/pagy/docs/api/javascript

# With the asset pipeline
# Sprockets need to look into the pagy javascripts dir, so add it to the assets paths
# Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')

# I18n

# Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# See https://ddnexus.github.io/pagy/docs/api/i18n
# Notice: No need to configure anything in this section if your app uses only "en"
#
# Examples:
# load the "de" built-in locale:
# Pagy::I18n.load(locale: 'de')
#
# load the "de" locale defined in the custom file at :filepath:
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# load the "de", "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
# load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )

# When you are done setting your own options freeze them, so they will not get changed accidentally
Pagy.options.freeze
