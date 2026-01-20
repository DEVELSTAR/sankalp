# frozen_string_literal: true

# This file should ensure the existence of records required to run the application.

puts "🌱 Seeding database..."

# Clear existing data in development/test
if Rails.env.development? || Rails.env.test?
  puts "Clearing existing data..."
  DailyActivity.delete_all
  SankalpRecord.with_deleted.delete_all
  User.delete_all
  Category.delete_all
end

# Create Categories
puts "Creating categories..."

categories_data = [
  { name: "Health", description: "Physical health, fitness, and wellness goals", color: "#10B981", icon: "heart" },
  { name: "Spiritual", description: "Meditation, prayer, and spiritual practices", color: "#8B5CF6", icon: "sun" },
  { name: "Learning", description: "Education, reading, and skill development", color: "#3B82F6", icon: "book" },
  { name: "Discipline", description: "Habits, routines, and self-improvement", color: "#F59E0B", icon: "target" },
  { name: "Career", description: "Professional growth and work-related goals", color: "#EF4444", icon: "briefcase" },
  { name: "Relationships", description: "Family, friends, and social connections", color: "#EC4899", icon: "users" },
  { name: "Finance", description: "Saving, budgeting, and financial goals", color: "#14B8A6", icon: "wallet" },
  { name: "Creativity", description: "Art, music, writing, and creative pursuits", color: "#F97316", icon: "palette" }
]

categories = categories_data.map do |data|
  Category.find_or_create_by!(name: data[:name]) do |category|
    category.description = data[:description]
    category.color = data[:color]
    category.icon = data[:icon]
  end
end

puts "✅ Created #{Category.count} categories"

# Create Admin User
puts "Creating admin user..."

admin = User.find_or_create_by!(email: "admin@sankalp.app") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.first_name = "Admin"
  user.last_name = "User"
  user.role = :admin
end

puts "✅ Admin user created: #{admin.email}"

# Create Demo User
puts "Creating demo user..."

demo_user = User.find_or_create_by!(email: "demo@sankalp.app") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.first_name = "Demo"
  user.last_name = "User"
  user.role = :user
end

puts "✅ Demo user created: #{demo_user.email}"

# Create Sample Sankalps for Demo User
if Rails.env.development?
  puts "Creating sample Sankalps..."

  sankalps_data = [
    {
      title: "Read 30 minutes daily",
      description: "Develop a consistent reading habit by dedicating at least 30 minutes every day to reading books.",
      category: categories.find { |c| c.name == "Learning" },
      status: :active,
      start_date: 30.days.ago.to_date,
      end_date: 60.days.from_now.to_date
    },
    {
      title: "Morning meditation",
      description: "Start each day with 15 minutes of mindfulness meditation to improve focus and reduce stress.",
      category: categories.find { |c| c.name == "Spiritual" },
      status: :active,
      start_date: 14.days.ago.to_date,
      end_date: nil
    },
    {
      title: "Exercise 4 times a week",
      description: "Maintain physical fitness through regular exercise sessions - gym, running, or yoga.",
      category: categories.find { |c| c.name == "Health" },
      status: :active,
      start_date: 21.days.ago.to_date,
      end_date: 90.days.from_now.to_date
    },
    {
      title: "Learn Ruby on Rails",
      description: "Complete a comprehensive course on Ruby on Rails and build 3 personal projects.",
      category: categories.find { |c| c.name == "Career" },
      status: :completed,
      start_date: 60.days.ago.to_date,
      end_date: 10.days.ago.to_date
    },
    {
      title: "Save ₹5000 monthly",
      description: "Consistently save at least ₹5000 every month towards emergency fund.",
      category: categories.find { |c| c.name == "Finance" },
      status: :active,
      start_date: 45.days.ago.to_date,
      end_date: nil
    },
    {
      title: "Wake up at 5 AM",
      description: "Develop an early morning routine by waking up at 5 AM consistently.",
      category: categories.find { |c| c.name == "Discipline" },
      status: :paused,
      start_date: 20.days.ago.to_date,
      end_date: nil
    }
  ]

  sankalps = sankalps_data.map do |data|
    demo_user.sankalps.create!(data)
  end

  puts "✅ Created #{sankalps.count} Sankalps"

  # Create Sample Daily Activities
  puts "Creating sample daily activities..."

  activity_count = 0
  sankalps.each do |sankalp|
    next if sankalp.paused?

    # Generate activities for past days
    days_count = (Date.current - sankalp.start_date).to_i
    days_count = [ days_count, 30 ].min # Limit to 30 days

    days_count.times do |i|
      activity_date = sankalp.start_date + i.days
      next if activity_date > Date.current

      # Skip some days randomly to make it realistic
      next if rand < 0.15 && sankalp.active?

      completed = rand < (sankalp.completed? ? 0.95 : 0.75)

      notes = if completed
                [
                  "Great progress today!",
                  "Feeling motivated",
                  "Completed as planned",
                  "Challenging but worth it",
                  nil,
                  nil
                ].sample
      else
                [
                  "Couldn't complete due to time constraints",
                  "Will make up for it tomorrow",
                  nil
                ].sample
      end

      sankalp.daily_activities.create!(
        activity_date: activity_date,
        completed: completed,
        notes: notes
      )
      activity_count += 1
    end
  end

  puts "✅ Created #{activity_count} daily activities"

  # Create a few more users for admin testing
  puts "Creating additional test users..."

  5.times do |i|
    user = User.create!(
      email: "user#{i + 1}@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: [ "Rahul", "Priya", "Amit", "Sneha", "Vikram" ][i],
      last_name: [ "Sharma", "Patel", "Kumar", "Singh", "Gupta" ][i],
      role: :user
    )

    # Create 1-3 sankalps for each user
    rand(1..3).times do
      category = categories.sample
      sankalp = user.sankalps.create!(
        title: [
          "Daily journaling",
          "No social media after 9 PM",
          "Learn a new language",
          "Practice gratitude",
          "Weekly family time",
          "Drink 8 glasses of water",
          "No processed food"
        ].sample,
        description: "Sample sankalp description",
        category: category,
        status: [ :active, :active, :completed, :paused ].sample,
        start_date: rand(10..30).days.ago.to_date,
        end_date: [ nil, rand(30..90).days.from_now.to_date ].sample
      )

      # Add some activities
      rand(5..15).times do |j|
        activity_date = sankalp.start_date + j.days
        next if activity_date > Date.current

        sankalp.daily_activities.create!(
          activity_date: activity_date,
          completed: rand < 0.7,
          notes: nil
        )
      rescue ActiveRecord::RecordInvalid
        # Skip duplicate dates
        next
      end
    end
  end

  puts "✅ Created 5 additional users with Sankalps"
end

puts ""
puts "🎉 Seeding complete!"
puts ""
puts "📋 Summary:"
puts "   - Categories: #{Category.count}"
puts "   - Users: #{User.count}"
puts "   - Sankalps: #{SankalpRecord.count}"
puts "   - Daily Activities: #{DailyActivity.count}"
puts ""
puts "🔑 Login Credentials:"
puts "   Admin: admin@sankalp.app / password123"
puts "   Demo:  demo@sankalp.app / password123"
puts ""
