feature 'Creating Peeps' do

  let(:user) do
    user = create :user
  end

  scenario 'can post a new peep to Chitter' do
    expect(Peep.count).to eq(0)
    sign_in(email: user.email,   password: user.password)
    visit '/peeps'
    fill_in 'text', with: 'peep message'
    click_button 'Submit Peep'
    expect(Peep.count).to eq(1)  #better to expect a peep message -- because BDD!
  end

  scenario 'can only peep if logged in' do
    expect(Peep.count).to eq(0)
    visit '/peeps'
    expect(page).not_to have_content('Peep now')
  end
end
