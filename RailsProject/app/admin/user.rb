ActiveAdmin.register User do

  remove_filter :users_groups
  remove_filter :users_follows
  remove_filter :users_followers
  remove_filter :users_friends
  remove_filter :users_friends_with

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
