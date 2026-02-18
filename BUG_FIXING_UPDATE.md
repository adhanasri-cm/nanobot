# Bug Fixing Capability - Setup Update

**Date**: 2026-02-17  
**Status**: ✅ Complete

Comprehensive bug-fixing and debugging capabilities have been added to your Nanobot React Developer Agent.

---

## What's New

Your agent can now **systematically debug and fix bugs** in your React/React Native code:

✅ **Reproduce bugs** from your description  
✅ **Find root causes** through code analysis and testing  
✅ **Write failing tests** that demonstrate the bug  
✅ **Fix bugs** with minimal, focused changes  
✅ **Verify fixes** with tests, linting, and building  
✅ **Create professional PRs** with clear explanations  

---

## Files Updated

| File | What Changed |
|------|--------------|
| **AGENTS.md** | Added "Bug Fixing Workflow" section with 6-step process |
| **SYSTEM_PROMPT.md** | Added "Debugging & Bug Fixing" section with patterns and strategies |
| **QUICK_TEST_CHECKLIST.md** | Added bug-fixing test scenario |
| **SETUP_SUMMARY.md** | Added bug-fixing overview and example |

## Files Created

| File | Purpose |
|------|---------|
| **BUG_FIXING_GUIDE.md** | Complete bug-fixing reference (500+ lines) |

---

## Bug Fixing Workflow

When you report a bug, the agent follows this systematic 6-step process:

### 1. Reproduce the Bug
- Ask for exact reproduction steps
- Check error messages and stack traces
- Try to reproduce locally
- Review recent commits

### 2. Understand Root Cause
- Read relevant code files
- Check TypeScript types
- Examine hooks dependencies
- Look for async/timing issues
- Analyze error handling

### 3. Write Failing Test
- Create test case that demonstrates the bug
- Test should fail with current code
- Use Jest + React Testing Library

### 4. Fix the Code
- Make minimal changes to fix the bug
- Follow React/TypeScript best practices
- Don't refactor unrelated code
- Use proper dependency arrays, type guards, etc.

### 5. Verify the Fix
- Run all tests: `npm run test`
- Check linting: `npm run lint`
- Verify TypeScript compiles: `npm run build`
- Ensure no related tests break

### 6. Create Fix PR
- Branch: `fix/short-bug-description`
- Title: `fix: brief description`
- Body: Explain bug, root cause, solution, testing

---

## Common Bug Patterns

The agent knows how to identify and fix:

### ✅ Missing useEffect Dependencies
```tsx
// WRONG: Missing dependency causes stale data
useEffect(() => {
  fetchData(userId);
}, []);  // userId is used but not in deps!

// FIXED: Add to dependencies
useEffect(() => {
  fetchData(userId);
}, [userId]);  // Now re-runs when userId changes
```

### ✅ Stale Closures
```tsx
// WRONG: Handler uses old state value
const [count, setCount] = useState(0);
const handleClick = () => {
  console.log(count);  // Always 0!
};

// FIXED: Use useCallback with dependencies
const handleClick = useCallback(() => {
  console.log(count);  // Current value
}, [count]);
```

### ✅ Async Race Conditions
```tsx
// WRONG: Old response overwrites new data
useEffect(() => {
  fetchData(id).then(setData);
}, [id]);

// FIXED: Ignore outdated responses
useEffect(() => {
  let isMounted = true;
  fetchData(id).then(data => {
    if (isMounted) setData(data);
  });
  return () => { isMounted = false; };
}, [id]);
```

### ✅ Type Errors (TypeScript)
```tsx
// WRONG: No type guard
const user = response.data;
console.log(user.email);  // Crash if undefined

// FIXED: Type guard before use
if (response.data && response.data.email) {
  console.log(response.data.email);
}
```

### ✅ Key Prop Issues
```tsx
// WRONG: Index as key causes state bugs
{items.map((item, idx) => <Item key={idx} />)}

// FIXED: Use unique ID
{items.map(item => <Item key={item.id} />)}
```

### ✅ Event Listener Leaks
```tsx
// WRONG: Listener added but never removed
useEffect(() => {
  window.addEventListener('resize', handleResize);
}, []);

// FIXED: Cleanup function removes listener
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => {
    window.removeEventListener('resize', handleResize);
  };
}, []);
```

And many more patterns documented in **BUG_FIXING_GUIDE.md**.

---

## How to Request a Bug Fix

### Good Bug Reports

**Be specific:**
```
When I change the user dropdown on the profile page, 
the form still shows the old user's data.
Console shows no errors.
This just started happening after the last commit.
```

**Include reproduction steps:**
```
1. Go to /profile
2. Select a different user from the dropdown
3. See that form still shows old user data
4. Close and reopen form - then it shows correct data
```

**With error messages:**
```
I get this error when uploading files:
TypeError: Cannot read property 'file' of undefined
at FileUpload.tsx:45
```

### The Agent Will

1. **Ask clarifying questions** if needed
2. **Read your code** to understand the problem
3. **Write a test** that fails with current code
4. **Find the bug** (missing dependency, type error, async issue, etc.)
5. **Fix with minimal changes** (not refactoring)
6. **Verify** all tests pass and lint checks pass
7. **Open a PR** with clear explanation

---

## Debugging Commands

The agent uses these tools to debug:

```bash
# Run tests in watch mode (best for debugging)
npm run test -- --watch

# Run specific test file
npm run test -- ComponentName.test.tsx

# Check test coverage
npm run test -- --coverage

# Check TypeScript compilation
npm run type-check

# Lint and find issues
npm run lint

# Verify build
npm run build

# For React Native: reset cache
npm start -- --reset-cache
```

---

## Debugging Techniques Used by Agent

### Console Logging Strategy
Agent adds strategic logs to trace execution:
```tsx
console.log('Component mounted with props:', props);
console.log('Effect running, userId:', userId);
console.log('Data fetched:', data);
```

### React DevTools Analysis
Agent uses React DevTools to:
- Inspect component state and props
- Check which components re-render
- Use Profiler to detect performance issues

### Browser DevTools Inspection
Agent checks:
- Console for JavaScript errors
- Network tab for API calls
- Elements for DOM structure
- Sources for code inspection

### Type Checking
Agent ensures:
- TypeScript types are correct
- No `any` types (uses `unknown` instead)
- Type guards before accessing properties

---

## Testing Bug Fixes

The agent always writes tests BEFORE fixing:

```tsx
describe('UserProfile', () => {
  test('should fetch new data when userId changes', async () => {
    const { rerender } = render(<UserProfile userId="1" />);
    
    await waitFor(() => {
      expect(screen.getByText(/User 1/i)).toBeInTheDocument();
    });

    // BUG: This doesn't work with the bug
    rerender(<UserProfile userId="2" />);

    await waitFor(() => {
      expect(screen.getByText(/User 2/i)).toBeInTheDocument();
    });
  });
});
```

---

## Documentation

### Quick References

| Document | Purpose |
|----------|---------|
| **BUG_FIXING_GUIDE.md** | Complete reference with 8 bug patterns and debugging strategies |
| **AGENTS.md** | Agent instructions (includes bug-fixing workflow) |
| **SYSTEM_PROMPT.md** | Best practices (includes debugging section) |

### When to Read

- **Just starting**: Read section below ("Get Started")
- **Need to fix a bug**: Describe it and agent will handle it
- **Want to understand debugging**: Read **BUG_FIXING_GUIDE.md**
- **Common patterns**: Check "Common Bug Patterns" above

---

## Get Started

### 1. Just Describe the Bug

Tell the agent about a bug in natural language:

```
"There's a bug where the search results don't update when I type in the search box.
The search runs once on page load, but changing the input doesn't trigger a new search."
```

### 2. Let the Agent Debug

The agent will:
- Read the search component code
- Identify missing dependency in useEffect
- Write test that reproduces the bug
- Add the search term to useEffect dependencies
- Verify all tests pass

### 3. Review the PR

The agent opens a PR like:
```
fix: add searchTerm to useEffect dependencies in SearchComponent

Bug: Search results don't update when user types in search box

Root Cause: useEffect was missing searchTerm in its dependency array,
so when the user typed (searchTerm changed), the effect didn't re-run.

Solution: Added searchTerm to the dependencies array of useEffect.

Testing: Added test case that reproduces the bug (now passes).
All existing tests still pass. Linting and build succeed.
```

---

## Benefits

### For You
✅ Bugs get fixed systematically, not with guesses  
✅ Root causes are understood and documented  
✅ Tests prevent similar bugs in the future  
✅ Code quality improves with each fix  

### For Your Team
✅ Bugs are fixed with minimal changes  
✅ PRs include clear explanation of the issue  
✅ Tests demonstrate and verify fixes  
✅ Code review process is cleaner  

### For Your Project
✅ Fewer regressions  
✅ Better test coverage  
✅ Clearer commit history  
✅ Knowledge shared through PR descriptions  

---

## Example: Real Bug Fix

**You report:**
```
Bug: User data doesn't update when switching between users.
Still shows old user's name and email.
```

**Agent does:**

1. Reads UserProfile.tsx - sees `useEffect` missing `userId` dependency
2. Writes test that fails:
   ```tsx
   test('should update profile when userId changes', async () => {
     const { rerender } = render(<UserProfile userId="1" />);
     await waitFor(() => expect(screen.getByText('Alice')).toBeInTheDocument());
     rerender(<UserProfile userId="2" />);
     await waitFor(() => expect(screen.getByText('Bob')).toBeInTheDocument()); // FAILS
   });
   ```
3. Fixes the code:
   ```tsx
   useEffect(() => {
     fetchUser(userId).then(setUser);
   }, [userId]);  // Added userId here
   ```
4. Test now passes ✅
5. All other tests pass ✅
6. No lint errors ✅
7. Build succeeds ✅
8. Opens PR with explanation

**You review and merge.**

---

## Troubleshooting

**Q: What if the agent's fix doesn't work?**  
A: The agent will re-examine the code and try a different approach. All fixes are tested first, so if a test passes, the fix is correct.

**Q: Can the agent fix bugs in TypeScript/build issues?**  
A: Yes. The agent checks `npm run build` and `npm run type-check` and understands TypeScript errors.

**Q: What about React Native bugs?**  
A: Yes. The agent knows React Native patterns and can debug Metro bundler issues, platform-specific code, etc.

**Q: How do I know the bug is really fixed?**  
A: The agent writes a test that fails with the bug and passes after fixing. Plus all existing tests continue to pass.

---

## Summary

Your Nanobot React Developer Agent now has **professional bug-fixing capabilities**:

1. **Reproduce** bugs from your description
2. **Analyze** code to find root causes
3. **Test** by writing cases that demonstrate the bug
4. **Fix** with minimal, focused changes
5. **Verify** with comprehensive testing
6. **Document** in clear PRs for review

**When you find a bug, just describe it—the agent handles the rest!**

---

**Reference**: See [BUG_FIXING_GUIDE.md](BUG_FIXING_GUIDE.md) for complete debugging strategies.

