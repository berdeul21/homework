require 'rails_helper'

RSpec.describe User, type: :model do
  it "사용가 없다" do
    expect(User.count).to eq 0
  end

  it "사용자를 이메일, 비밀번호, 닉네임, 성별, 생년월로 생성한다" do
    user = User.create(
    		email: Faker::Internet.email,
    		password: Faker::Internet.password,
    		nickname: 'ohou',
    		gender: Faker::Gender.binary_type,
    		birth: '201906',
    	)
    expect(User.count).to eq 1
  end

  it "사용자를 닉네임으로 구분한다" do
    user = User.create(
    		email: Faker::Internet.email,
    		password: Faker::Internet.password,
    		nickname: 'ohou',
    		gender: Faker::Gender.binary_type,
    		birth: '201906',
    	)
    expect(User.count).to eq 1
  end
end