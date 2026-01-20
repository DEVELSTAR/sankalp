# Renaming Sankalp Model to Resolve Namespace Conflict

## Objective
Resolve the naming conflict between the `Sankalp` model and the application module `Sankalp` (defined in `config/application.rb`).

## Solution
Instead of renaming the concept to "Commitment", we kept the domain term "Sankalp" but resolved the technical conflict by:
1.  Renaming the Active Record model class from `Sankalp` to `SankalpRecord`.
2.  Overriding `model_name` in `SankalpRecord` to return "Sankalp". This ensures that Rails routing helpers (`sankalp_path`) and form parameter keys (`params[:sankalp]`) remain consistent and clean.
3.  Updating all associations and references to point to `SankalpRecord`.

## Changes

### Model
- **File:** `app/models/sankalp_record.rb` (renamed from `sankalp.rb`)
- **Class:** `SankalpRecord`
- **Table:** `sankalps` (explicitly set)
- **Configuration:**
  ```ruby
  def self.model_name
    ActiveModel::Name.new(self, nil, "Sankalp")
  end
  ```

### Associations
- **User:** `has_many :sankalps, class_name: "SankalpRecord", dependent: :destroy`
- **Category:** `has_many :sankalps, class_name: "SankalpRecord"`
- **DailyActivity:** `belongs_to :sankalp, class_name: "SankalpRecord"`

### Controllers
- Updated `SankalpsController` and `Admin::SankalpsController` to query `SankalpRecord` but permit `:sankalp` params.
- `DashboardController`, `DailyActivitiesController` updated to work with the new class name.
- `ApplicationController`: Added `require_admin!` and updated `Pagy` configuration.

### Views
- Updated forms and views to work with the `SankalpRecord` objects.
- Explicit path helpers were temporarily added but then reverted to standard helpers (`link_to sankalp`) as the `model_name` override makes them work seamlessly.

### Policy
- Renamed `SankalpPolicy` to handle authorization for `SankalpRecord`.

### Testing
- Updated all RSpec tests to reflect the changes.
- All 76 examples are passing.

## Verification
- **Browser:** Verified login, dashboard, "My Sankalps" page, and detail pages.
- **Automated Tests:** Full RSpec suite passing.
