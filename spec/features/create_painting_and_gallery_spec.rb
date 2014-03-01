require 'spec_helper'

feature "Create Painting for gallery" do
  background do
    Gallery.create(:name => "test")
  end
  scenario "create a gallery" do
    visit "/galleries/new"

    within("#new_gallery") do
      fill_in "Name", :with => 'gallery'
      fill_in "Description", :with => 'test gallery'
    end
    click_button "Create Gallery"

    expect(page).to have_content "Successfully created gallery"
  end

  scenario "create a painting for a gallery" do
    visit "/galleries/#{Gallery.first.id}"
    click_link "Add a Painting"

    within("#new_painting") do
      fill_in "Name", :with => 'painting'
      fill_in "Description", :with => 'painting description'
    end
    click_button "Create Painting"

    expect(page).to have_content "Successfully created painting"
  end
end
