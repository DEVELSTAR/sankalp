# 🎯 Sankalp - Commitment Tracking Application

Sankalp is a full-stack Ruby on Rails application that helps users create, track, and complete personal or group Sankalps (commitments/goals) with daily activity logging and progress tracking.

## ✨ Features

### User Management
- User sign up, login, logout with Devise
- Profile management
- Role-based access (User, Admin)

### Sankalp Management
- Create, edit, delete Sankalps (soft delete)
- Fields: title, description, category, start_date, end_date, status
- Status options: Active, Completed, Paused
- Filter by status and category
- Progress tracking with completion percentage

### Categories
- Pre-defined categories (Health, Spiritual, Learning, Discipline, etc.)
- Admin can manage categories
- Color-coded for visual distinction

### Daily Activity Tracking
- Log daily activity for each Sankalp
- Track completion status and notes
- One activity per Sankalp per day
- **Streak calculation** - Track consecutive days of completion
- Completion percentage tracking

### Dashboards
**User Dashboard:**
- Active Sankalps overview
- Today's pending activities
- Current streaks
- Progress bars

**Admin Dashboard:**
- Total users and Sankalps
- Active vs completed statistics
- Category-wise breakdown
- Recent activity

### Access Control
- Users can only manage their own Sankalps
- Admin can view and manage everything
- Pundit-based authorization

## 🛠 Tech Stack

- **Backend:** Ruby on Rails 8.1
- **Ruby:** 3.4+
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Authorization:** Pundit
- **Frontend:** Rails views with Hotwire/Turbo
- **Styling:** Tailwind CSS
- **Pagination:** Pagy
- **Soft Delete:** acts_as_paranoid
- **Testing:** RSpec, FactoryBot, Shoulda Matchers

## 🚀 Getting Started

### Prerequisites

- Ruby 3.4+
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sankalp
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Access the application**
   Open http://localhost:3000 in your browser

### Default Login Credentials

After running seeds:

| Role  | Email               | Password     |
|-------|---------------------|--------------|
| Admin | admin@sankalp.app   | password123  |
| User  | demo@sankalp.app    | password123  |

## 🧪 Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific tests
bundle exec rspec spec/models/
bundle exec rspec spec/requests/

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 📁 Project Structure

```
app/
├── controllers/
│   ├── admin/           # Admin controllers
│   ├── application_controller.rb
│   ├── categories_controller.rb
│   ├── daily_activities_controller.rb
│   ├── dashboard_controller.rb
│   ├── profiles_controller.rb
│   └── sankalps_controller.rb
├── models/
│   ├── category.rb
│   ├── daily_activity.rb
│   ├── sankalp.rb
│   └── user.rb
├── policies/            # Pundit authorization policies
├── views/
│   ├── admin/           # Admin views
│   ├── categories/
│   ├── daily_activities/
│   ├── dashboard/
│   ├── devise/          # Authentication views
│   ├── layouts/
│   ├── profiles/
│   ├── sankalps/
│   └── shared/          # Shared partials
└── javascript/
    └── controllers/     # Stimulus controllers
```

## 🌐 Deployment to Render

### Prerequisites
- Render account
- PostgreSQL database on Render

### Steps

1. **Create a new Web Service on Render**
   - Connect your GitHub repository
   - Select the repository

2. **Configure the service**
   ```yaml
   Build Command: bundle install && rails assets:precompile && rails db:migrate
   Start Command: bundle exec puma -C config/puma.rb
   ```

3. **Environment Variables**
   Add the following environment variables:
   ```
   RAILS_ENV=production
   RAILS_MASTER_KEY=<your-master-key>
   DATABASE_URL=<your-postgres-url>
   SECRET_KEY_BASE=<generated-secret>
   ```

4. **Create PostgreSQL database on Render**
   - Create a new PostgreSQL instance
   - Copy the Internal Database URL
   - Add as DATABASE_URL environment variable

5. **Deploy**
   - Render will automatically deploy on push to main branch

### render.yaml (Blueprint)

```yaml
databases:
  - name: sankalp-db
    databaseName: sankalp
    plan: free

services:
  - type: web
    name: sankalp
    runtime: ruby
    buildCommand: bundle install && bundle exec rails assets:precompile && bundle exec rails db:migrate
    startCommand: bundle exec puma -C config/puma.rb
    envVars:
      - key: RAILS_ENV
        value: production
      - key: RAILS_MASTER_KEY
        sync: false
      - key: DATABASE_URL
        fromDatabase:
          name: sankalp-db
          property: connectionString
```

## 📊 Database Schema

### Users
- email, encrypted_password (Devise)
- first_name, last_name
- role (enum: user, admin)

### Categories
- name (unique)
- description
- color
- icon

### Sankalps
- title
- description
- status (enum: active, completed, paused)
- start_date, end_date
- user_id, category_id
- deleted_at (soft delete)

### DailyActivities
- sankalp_id
- activity_date
- notes
- completed (boolean)
- Unique constraint on [sankalp_id, activity_date]

## 🔒 Security Features

- Devise authentication with secure password hashing
- Pundit authorization for resource access control
- CSRF protection
- Content Security Policy headers
- Parameter filtering for sensitive data

## 📝 API Routes

```
# Authentication
devise_for :users

# Main resources
root                     -> dashboard#index
resources :sankalps do
  resources :daily_activities do
    post :toggle, on: :member
  end
end
resources :categories (read-only for users)
resource :profile

# Admin namespace
namespace :admin do
  root                   -> dashboard#index
  resources :users
  resources :sankalps
  resources :categories
end
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Ruby on Rails community
- Tailwind CSS for beautiful styling
- Hotwire for modern frontend interactivity
