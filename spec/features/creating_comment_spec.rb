feature 'Creating Comments' do

  let(:user) do
    user = create :user
  end

  scenario 'can add a comment to a peep' do
    expect(Peep.count).to eq(0)
    sign_in(email: user.email,   password: user.password)
    visit '/peeps'
    fill_in 'text', with: 'peep message'
    click_button 'Submit Peep'
    click_link 'comments'
    fill_in 'text', with: 'comment message'
    click_button 'Submit'
    expect(Comment.count).to eq(1)  #better to expect a peep message -- because BDD!
  end

end
