require 'rails_helper'

RSpec.describe User, type: :model do
	context "사용자를 생성한다" do
	  it "사용자를 이메일, 비밀번호, 닉네임, 성별, 생년월을 입력하여 생성한다" do
	  	expect(User.count).to eq 0

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
	    User.create(
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
		it "카테고리, 설명을 입력하여 사진을 생성할 수 있다" do
			expect(Photo.where(user_id: user.id).count).to eq 0

	    Photo.create(
	    		user_id: user.id,
	    		image_url: Faker::Avatar.image("my-own-slug", "50x50", "jpg"),
	    		category: Faker::House.room,
	    		description: Faker::Lorem.paragraph
	    	)
	    expect(Photo.where(user_id: user.id).count).to eq 1
	  end
	end

	3.times.each do |i|
		let("photo#{i}".to_sym) { 
					Photo.create(
	    		user_id: user.id,
	    		image_url: Faker::Avatar.image("my-own-slug", "50x50", "jpg"),
	    		category: Faker::House.room,
	    		description: Faker::Lorem.paragraph
	    	) }
	end
	let(:album) { Album.create(
					user_id: user.id,
					summary: Faker::Lorem.paragraph
				) }

	context "사용자는 사진 묶음을 생성한다" do
		it "요약글을 입력하여 사진묶음을 생성한다" do
			expect(Album.where(user_id: user.id).count).to eq 0

			Album.create(
					user_id: user.id,
					summary: Faker::Lorem.paragraph
				)
			expect(Album.where(user_id: user.id).count).to eq 1
		end

		it "사진을 순서를 입력하여 사진묶음에 넣는다" do
			Collect.create(
					album_id: album.id,
					photo_id: photo0.id,
					seq: 2
				)
			Collect.create(
					album_id: album.id,
					photo_id: photo1.id,
					seq: 1
				)
			expect(album.collects.order('seq ASC').pluck(:photo_id)).to eq [photo1.id, photo0.id]
		end

		it "사진묶음의 대표사진을 지정한다" do
			Collect.create(
					album_id: album.id,
					photo_id: photo2.id,
					seq: 3,
					cover: true
				)
			expect(album.collects.find_by(cover: true).photo.id).to eq photo2.id
		end
	end

	context "사용자는 댓글을 생성한다" do
		it "사진에 댓글을 생성한다" do
			expect(photo1.comments.count).to eq 0

			photo1.comments.create(
					user_id: user.id,
					body: Faker::Lorem.sentence
				)
			expect(photo1.comments.count).to eq 1
		end

		it "사진묶음에 댓글을 생성한다" do
			expect(album.comments.count).to eq 0

			album.comments.create(
					user_id: user.id,
					body: Faker::Lorem.sentence
				)
			expect(album.comments.count).to eq 1
		end
	end
end
