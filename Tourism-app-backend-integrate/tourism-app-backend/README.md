# Tourism App Backend

This is the backend server for the Tourism App, built with Node.js, Express, and MongoDB.

## Features

- User Authentication (Login/Signup)
- Admin Authorization
- Destination Management
- Hotel Management
- Wishlist Management
- User Feedback System

## Prerequisites

- Node.js (v14 or higher)
- MongoDB
- Postman (for testing)

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file in the root directory with the following variables:
   ```
   MONGODB_URI=mongodb://localhost:27017/tourism-app
   JWT_SECRET=your_jwt_secret_key
   PORT=5000
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

## API Endpoints

### Authentication
- POST `/api/auth/register` - Register a new user
- POST `/api/auth/login` - Login user
- GET `/api/auth/me` - Get current user
- POST `/api/auth/logout` - Logout user

### Destinations
- GET `/api/destinations` - Get all destinations
- GET `/api/destinations/:id` - Get single destination
- POST `/api/destinations` - Create destination (Admin only)
- PUT `/api/destinations/:id` - Update destination (Admin only)
- DELETE `/api/destinations/:id` - Delete destination (Admin only)
- GET `/api/destinations/search/:query` - Search destinations

### Hotels
- GET `/api/hotels` - Get all hotels
- GET `/api/hotels/:id` - Get single hotel
- POST `/api/hotels` - Create hotel (Admin only)
- PUT `/api/hotels/:id` - Update hotel (Admin only)
- DELETE `/api/hotels/:id` - Delete hotel (Admin only)
- GET `/api/hotels/search/:query` - Search hotels

### Wishlist
- GET `/api/wishlist` - Get user's wishlist
- POST `/api/wishlist/destinations/:id` - Add destination to wishlist
- DELETE `/api/wishlist/destinations/:id` - Remove destination from wishlist
- POST `/api/wishlist/hotels/:id` - Add hotel to wishlist
- DELETE `/api/wishlist/hotels/:id` - Remove hotel from wishlist

### Feedback
- GET `/api/feedback` - Get all feedback (Admin only)
- GET `/api/feedback/me` - Get user's feedback
- POST `/api/feedback` - Create feedback
- PUT `/api/feedback/:id` - Update feedback
- DELETE `/api/feedback/:id` - Delete feedback

## Testing with Postman

1. Import the provided Postman collection (if available)
2. Set up environment variables in Postman:
   - `BASE_URL`: http://localhost:5000
   - `TOKEN`: (after login, set this to the received token)

3. Test the endpoints:
   - First register a user
   - Login to get the token
   - Use the token in the Authorization header for protected routes

## Error Handling

The API uses standard HTTP status codes:
- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Server Error 