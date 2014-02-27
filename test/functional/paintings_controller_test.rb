require 'test_helper'

class PaintingsControllerTest < ActionController::TestCase

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Painting.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Painting.any_instance.stubs(:valid?).returns(true)
    gallery = Gallery.first
    Painting.any_instance.stubs(:gallery).returns(gallery)
    post :create
    assert_redirected_to gallery_url(gallery)
  end

  def test_edit
    get :edit, :id => Painting.first
    assert_template 'edit'
  end

  def test_update_invalid
    Painting.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Painting.first
    assert_template 'edit'
  end

  def test_update_valid
    Painting.any_instance.stubs(:valid?).returns(true)
    gallery = Gallery.first
    Painting.any_instance.stubs(:gallery).returns(gallery)
    put :update, :id => Painting.first
    assert_redirected_to gallery_url(gallery)
  end

  def test_destroy
    painting = Painting.first
    gallery = Gallery.first
    Painting.any_instance.stubs(:gallery).returns(gallery)
    delete :destroy, :id => painting
    assert_redirected_to gallery_url(gallery)
    assert !Painting.exists?(painting.id)
  end
end
