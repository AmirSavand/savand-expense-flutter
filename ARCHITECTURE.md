# Architecture

## Data Categories

### Master Data

Profiles, wallets, categories, any small, reference-level dataset.

- Fetched once per session, cached in memory for its lifetime.
- CRUD operations mutate the in-memory list directly, no refetch.
- Uses `NotifierProvider` with sealed states (`Initial`, `Loading`, `Loaded`,
  `Error`).
- Watches `currentProfileProvider` in `build()` to auto-reload on profile
  switch.

### Transactional Data

Transactions, high-volume, paginated, time-sensitive.

- Never cached. Every mount fetches fresh data from the API.
- Uses `FutureProvider.family`. Write operations use separate
  `AsyncNotifierProvider`.
- Uses `ref.read` for profile ID, not `ref.watch`, see Profile Switch Contract.

---

## Profile Switch Contract

Profile is the root of all data. On profile switch, the app navigates to
Dashboard
and the full widget tree rebuilds. Master data reloads via `watch`,
transactional
data refetches via remount. No manual invalidation needed.

This is why `ref.read` is correct in transactional providers, by the time they
run
after a profile switch, the widget tree is already fresh.

---

## Navigation-Driven Freshness

Transactional data relies on navigation to stay fresh, not manual invalidation.
Every list or detail screen fetches on mount. Deleting or saving navigates away,
causing the list to remount and refetch naturally.

This contract breaks if you mutate transactional data without navigating away
(e.g. inline swipe-to-delete). In that case you must call `ref.invalidate`
explicitly.
