require "application_system_test_case"

class SearchTermsTest < ApplicationSystemTestCase
  setup do
    @search_term = search_terms(:one)
  end

  test "visiting the index" do
    visit search_terms_url
    assert_selector "h1", text: "Search Terms"
  end

  test "creating a Search term" do
    visit search_terms_url
    click_on "New Search Term"

    fill_in "Term", with: @search_term.term
    fill_in "Timespan", with: @search_term.timespan
    click_on "Create Search term"

    assert_text "Search term was successfully created"
    click_on "Back"
  end

  test "updating a Search term" do
    visit search_terms_url
    click_on "Edit", match: :first

    fill_in "Term", with: @search_term.term
    fill_in "Timespan", with: @search_term.timespan
    click_on "Update Search term"

    assert_text "Search term was successfully updated"
    click_on "Back"
  end

  test "destroying a Search term" do
    visit search_terms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Search term was successfully destroyed"
  end
end
