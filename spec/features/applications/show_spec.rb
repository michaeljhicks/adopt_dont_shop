require 'rails_helper'

RSpec.describe 'applications show page' do

  it "displays applicant attributes" do
    application_1 = Application.create(name: 'Michael Hicks', address: '4012 Tracy St NE', city: 'Albuquerque', state: 'NM', zipcode: 87111, description: 'Really REALLY good guy', status: 'Pending')
    shelter_1 = Shelter.create(name: 'El Dorado Shelter', city: 'Albuquerque, NM', foster_program: false, rank: 9)
    pet_1 = Pet.create(name: 'Queso', breed: 'Boston Terrier', age: 5, adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(name: 'Gibblets', breed: 'French Bulldog', age: 3, adoptable: true, shelter_id: shelter_1.id)
    PetApplication.create(pet: pet_1, application: application_1)

    visit "/applications/#{application_1.id}"
    # save_and_open_page

    expect(page).to have_content(application_1.name)
    expect(page).to have_content(application_1.address)
    expect(page).to have_content(application_1.city)
    expect(page).to have_content(application_1.state)
    expect(page).to have_content(application_1.zipcode)
    expect(page).to have_content(application_1.description)
    expect(page).to have_content(application_1.status)
  end

  it 'can display Adopt This Pet button next to each pets name' do
    application_1 = Application.create(name: 'Michael Hicks', address: '4012 Tracy St NE', city: 'Albuquerque', state: 'NM', zipcode: 87111, description: 'Really REALLY good guy', status: 'In Progress')
    shelter_1 = Shelter.create(name: 'El Dorado Shelter', city: 'Albuquerque, NM', foster_program: false, rank: 9)
    pet_1 = Pet.create(name: 'Queso', breed: 'Boston Terrier', age: 5, adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(name: 'Gibblets', breed: 'French Bulldog', age: 3, adoptable: true, shelter_id: shelter_1.id)


    # Add a Pet to an Application

    # As a visitor
    # When I visit an application's show page
    visit "/applications/#{application_1.id}"
    expect(page).to_not have_content('Queso')
    # And I search for a Pet by name
    # within ("#pet_search-#{application_1.id}") do
      fill_in(:search, with: 'Queso')
      click_button("Search")
    # end
    # And I see the names Pets that match my search
    # Then next to each Pet's name I see a button to "Adopt this Pet"
    # When I click one of these buttons
    click_link("Adopt this Pet")
    # Then I am taken back to the application show page
    expect(current_path).to eq("/applications/#{application_1.id}")
    # And I see the Pet I want to adopt listed on this application
    expect(page).to have_content("Queso")
  end

  it 'after pets added to app - description prompt & submit button appears' do
    application_1 = Application.create(name: 'Michael Hicks', address: '4012 Tracy St NE', city: 'Albuquerque', state: 'NM', zipcode: 87111, description: 'Really REALLY good guy', status: 'In Progress')
    shelter_1 = Shelter.create(name: 'El Dorado Shelter', city: 'Albuquerque, NM', foster_program: false, rank: 9)
    pet_1 = Pet.create(name: 'Queso', breed: 'Boston Terrier', age: 5, adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(name: 'Gibblets', breed: 'French Bulldog', age: 3, adoptable: true, shelter_id: shelter_1.id)

    visit "/applications/#{application_1.id}"
    expect(page).to_not have_content('Queso')

    fill_in(:search, with: 'Queso')
    click_button("Search")

    click_link("Adopt this Pet")

    fill_in(:description, with: 'Really REALLY good guy')

    click_button("submit")

    expect(current_path).to eq("/applications/#{application_1.id}")


    expect(page).to_not have_content("In Progress")

    expect(page).to have_content("Pending")
  end

  it "doesn't show submit if you haven't added pets" do
    application_1 = Application.create(name: 'Michael Hicks', address: '4012 Tracy St NE', city: 'Albuquerque', state: 'NM', zipcode: 87111, description: 'Really REALLY good guy', status: 'In Progress')
    shelter_1 = Shelter.create(name: 'El Dorado Shelter', city: 'Albuquerque, NM', foster_program: false, rank: 9)
    pet_1 = Pet.create(name: 'Queso', breed: 'Boston Terrier', age: 5, adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(name: 'Gibblets', breed: 'French Bulldog', age: 3, adoptable: true, shelter_id: shelter_1.id)

    visit "/applications/#{application_1.id}"
    expect(page).to_not have_content("submit")
  end

  it "can display both partial search and case insensitive matches" do
    application_1 = Application.create(name: 'Michael Hicks', address: '4012 Tracy St NE', city: 'Albuquerque', state: 'NM', zipcode: 87111, description: 'Really REALLY good guy', status: 'In Progress')
    shelter_1 = Shelter.create(name: 'El Dorado Shelter', city: 'Albuquerque, NM', foster_program: false, rank: 9)
    pet_1 = Pet.create(name: 'Queso', breed: 'Boston Terrier', age: 5, adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(name: 'Gibblets', breed: 'French Bulldog', age: 3, adoptable: true, shelter_id: shelter_1.id)

    # As visitor when I visit an applications show page
    visit "/applications/#{application_1.id}"
    # And I search for Pets by name
    fill_in :search, with: "que"
    click_on("Search")
    # Then I see any pet whose name PARTIALLY matches my search
    expect(page).to have_content(pet_1.name)
    expect(page).to_not have_content(pet_2.name)
  end
end
