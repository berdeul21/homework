require 'rails_helper'

RSpec.describe User, type: :model do
	context "사용자를 생성한다" do
	  it "사용가 없다" do
	    expect(User.count).to eq 0
	  end

	  it "사용자를 이메일, 비밀번호, 닉네임, 성별, 생년월을 입력하여 생성한다" do
	    user = User.create(
	    		email: Faker::Internet.email,
	    		password: Faker::Internet.password,
	    		nickname: 'ohou',
	    		gender: Faker::Gender.binary_type,
	    		birth: '201906'
	    	)
	    expect(User.count).to eq 1
	  end

	  it "사용자를 닉네임으로 구분한다" do
	    user = User.create(
	    		email: Faker::Internet.email,
	    		password: Faker::Internet.password,
	    		nickname: 'ohou',
	    		gender: Faker::Gender.binary_type,
	    		birth: '201906'
	    	)
	    expect(User.count).to eq 1
	  end
	end 

	let(:user) { User.create(
	    		email: Faker::Internet.email,
	    		password: Faker::Internet.password,
	    		nickname: 'ohou',
	    		gender: Faker::Gender.binary_type,
	    		birth: '201906'
	    	) }

	context "사용자는 사진을 생성한다" do
		it "사용가는 카테고리, 설명을 입력하여 사진을 생성할 수 있다" do
	    Photo.create(
	    		user_id: user.id,
	    		image_url: Faker::Avatar.image("my-own-slug", "50x50", "jpg"),
	    		category: Faker::House.room,
	    		description: Faker::Lorem.paragraph
	    	)
	    expect(Photo.where(user_id: user.id).count).to eq 1
	  end
	end
end
