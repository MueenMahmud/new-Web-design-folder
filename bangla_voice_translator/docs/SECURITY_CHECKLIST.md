# Security Checklist

## API Security

- [ ] OpenAI API key stored as environment variable, not hardcoded
- [ ] API keys excluded from version control (`.gitignore`)
- [ ] HTTPS enforced for all API communications
- [ ] API request rate limiting implemented
- [ ] API error responses do not expose internal details

## Firebase Security

- [ ] Firestore security rules enforce user-owned data access
- [ ] Authentication required for all data operations
- [ ] Data validation rules in Firestore (field types, size limits)
- [ ] Anonymous users have limited access
- [ ] Firebase App Check enabled for API abuse prevention
- [ ] Cloud Functions use service account with minimal permissions

## Authentication

- [ ] Password minimum length enforced (8+ characters)
- [ ] Email verification enabled
- [ ] Brute force protection via Firebase Auth
- [ ] Secure session management
- [ ] Sign-out clears local session data
- [ ] Guest mode data isolated from authenticated users

## Data Protection

- [ ] User data encrypted at rest (Firebase default)
- [ ] Audio recordings stored temporarily and cleaned up
- [ ] Local storage does not contain sensitive data in plaintext
- [ ] Translation data scoped to user ID
- [ ] No PII logged in analytics events
- [ ] GDPR-compliant data handling

## Network Security

- [ ] Certificate pinning considered for production
- [ ] No sensitive data in URL parameters
- [ ] Request/response logging disabled in production
- [ ] Timeout configured for all network requests
- [ ] Retry logic with exponential backoff

## App Security

- [ ] ProGuard/R8 obfuscation enabled for Android release
- [ ] Debug mode disabled in release builds
- [ ] No debug logging in production
- [ ] Permissions requested at runtime (microphone)
- [ ] Minimal permissions declared in manifest
- [ ] App signing keys secured and backed up

## Dependency Security

- [ ] All dependencies from trusted sources (pub.dev)
- [ ] Dependencies pinned to specific versions
- [ ] Regular dependency updates for security patches
- [ ] No known vulnerabilities in dependencies
- [ ] Supply chain verification (7+ day old versions preferred)

## Code Security

- [ ] Input validation on all user inputs
- [ ] No SQL injection vectors (using parameterized queries)
- [ ] XSS prevention in web views (if applicable)
- [ ] Memory management for audio buffers
- [ ] Error handling does not expose stack traces to users
