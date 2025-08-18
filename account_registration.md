# User Story
**Title:**  
_As a user, I want to register with my name, username, age, and country, so that I can create an account and access the habit tracking features._  

**Acceptance Criteria:**  
1. User can enter **name**, **username**, **age**, and **country** in the registration form.  
2. Username must be **unique** (system should reject duplicates).  
3. Age must be a **valid number** and not left empty.  
4. Country should be selected from a **dropdown list**.  
5. All fields are **mandatory**; the system shows validation errors if any are missing/invalid.  
6. On successful registration, a **new user account is saved** in the database.  
7. User sees a confirmation message (e.g., _“Account created successfully!”_).  

**Priority:** High  

**Story Points:** 5  

**Notes:**  
- The user is able to register; however, due to security constraints, the credentials are not saved in the browser cache but are removed once the user logs out. Therefore, the user is unable to log in with their own credentials. The only way to log in is with the default username and password.  
- Ensure the registration form is **mobile-friendly**.  
- Edge case: Handle network failure gracefully (retry or show error message).  
