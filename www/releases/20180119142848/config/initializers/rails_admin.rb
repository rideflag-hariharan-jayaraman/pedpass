RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true


  index_show_only = [
    'User', 'Device', 'Crossing', 'DetectedCorner'
  ]

  dont_destroy = ['Corner']
  dont_create_or_destroy = ['CrossingFailureReason', 'Setting']

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except (index_show_only + dont_create_or_destroy)
    end
    export
    bulk_delete
    show
    edit do
      except index_show_only
    end
    delete do
      except (index_show_only + dont_create_or_destroy + dont_destroy)
    end
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models = ['DetectedNode', 'Node']


  #### MODEL CONFIGS
  ## NOTE: Moving it here as it inteferes with running rspec

  ## --------------------------- DetectedCorner ---------------------------
  config.model 'DetectedCorner' do
    configure :created_at do
      pretty_value do
        value.strftime '%b %e %Y, %T'
      end
      export_value do
        value.strftime '%b %e %Y, %T'
      end
    end
  end

  config.model 'DetectedBeacon' do
    configure :created_at do
      pretty_value do
        value.strftime '%b %e %Y, %T'
      end
      export_value do
        value.strftime '%b %e %Y, %T'
      end
    end
  end


  ## --------------------------- Beacon ---------------------------
  config.model 'Beacon' do
    list do
      field :id
      field :name
      include_all_fields
    end

    exclude_fields :beacon_id
  end

  ## --------------------------- Setting ---------------------------
  config.model 'Setting' do
    list do
      field :var do
        label 'Setting'
      end
      field :value do
        pretty_value do       # used in list view columns and show views, defaults to formatted_value for non-association fields
          YAML.load(value)    # required to display the YAML value
        end
      end
    end

    show do
      field :var do
        label 'Setting'
      end
      field :value do
        pretty_value do       # used in list view columns and show views, defaults to formatted_value for non-association fields
          YAML.load(value)    # required to display the YAML value
        end
      end
    end

    edit do
      field :var do
        label 'Setting'
        read_only true
      end
      field :value do
        formatted_value do    # used in form views
          YAML.load(value)    # required to display the YAML value
        end
      end
    end
  end
end
