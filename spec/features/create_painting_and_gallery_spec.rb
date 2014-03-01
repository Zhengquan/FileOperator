require 'spec_helper'

feature "Create Painting for gallery" do
  scenario "create a gallery" do
    visit "/galleries/new"

    within("#new_gallery") do
      fill_in "Name", :with => 'gallery'
      fill_in "Description", :with => 'test gallery'
    end
    click_link "Create Gallery"
    expect(page).to have_content "Successfully created gallery"
  end
end
