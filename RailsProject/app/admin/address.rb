ActiveAdmin.register Address do

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

form do |f|
  f.semantic_errors # shows errors on :base
  #f.inputs

  f.inputs do
	  fieldset do
		  ol do
			  li do
				  f.label :numberStreet
				  f.text_field :numberStreet
			  end
			  li do
				  f.label :complement
				  f.text_field :complement
			  end
			  li do
				  f.label :street
				  f.text_field :street
			  end
			  li do
				  f.label :city
				  f.text_field :city
			  end
			  li do
				  f.label :country
				  f.text_field :country
			  end
			  li do
				  f.label :zipcode
				  f.text_field :zipcode
			  end
			end
		end
	end

  f.actions         # adds the 'Submit' and 'Cancel' buttons
end


end
