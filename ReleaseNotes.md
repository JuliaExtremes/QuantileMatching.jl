# Release Notes

## 0.2.0

- Refactored `match()` for scalar matching.  
  The function can now be broadcast to match a vector.

- Added an exception to parametric matching when the actual value to match is outside the support of the actual distribution.  
  This situation can occur when the actual value lies outside the support of the actual distribution while the target distribution is unbounded. In such cases, the returned matched value is `Inf`.
