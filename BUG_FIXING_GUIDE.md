# Bug Fixing Guide - Nanobot React Agent

This guide explains how your Nanobot React Developer Agent handles bug fixing and debugging.

---

## Overview

The agent is equipped to:
- **Reproduce bugs** from your description
- **Understand root causes** through code analysis
- **Write failing tests** that demonstrate the bug
- **Fix bugs systematically** with minimal changes
- **Verify fixes** with testing and linting
- **Create professional PR** for code review

---

## Bug Fixing Workflow

### Step 1: Reproduce the Bug

**What you do:**
```
I'm seeing an error when users click the submit button. 
The form data isn't being sent. Error: "Cannot read property 'email' of undefined"
```

**Agent will:**
1. Ask clarifying questions:
   - When did this start happening?
   - Does it happen consistently or intermittently?
   - What's the exact reproduction steps?
   - Any error messages in console?

2. Read the relevant code:
   ```bash
   read_file("src/components/Form.tsx")
   read_file("src/services/api.ts")
   ```

3. Try to reproduce locally
4. Check git history for recent changes

### Step 2: Analyze & Find Root Cause

**Agent examines:**
- Code logic and flow
- Type definitions (TypeScript)
- Dependencies (useEffect deps, prop drilling)
- Async handling (promises, loading states)
- Error handling and edge cases

**Example bug analysis:**

```
BUG: Form submission fails
ROOT CAUSE: useEffect missing userId in dependencies
- useEffect calls fetchFormData(userId)
- But userId is not in dependency array
- So when userId changes, effect doesn't re-run
- Component uses stale data
```

### Step 3: Write Failing Test

**Agent creates test that demonstrates bug:**

```tsx
// Before fix: This test fails
test('should fetch data when user ID changes', async () => {
  const { rerender } = render(<Form userId="user-1" />);
  
  await waitFor(() => {
    expect(screen.getByText(/loading data.../i)).toBeInTheDocument();
  });

  // Change user
  rerender(<Form userId="user-2" />);

  // Should refetch (BUG: doesn't happen!)
  await waitFor(() => {
    expect(screen.getByText(/user-2/i)).toBeInTheDocument();
  });
});
```

### Step 4: Fix the Bug

**Agent makes minimal code changes:**

```tsx
// BEFORE (buggy)
useEffect(() => {
  fetchData(userId);
}, []);  // Missing dependency!

// AFTER (fixed)
useEffect(() => {
  fetchData(userId);
}, [userId]);  // userId added to dependencies
```

**Key principle:** Only change what's necessary to fix the bug. Don't refactor unrelated code.

### Step 5: Verify the Fix

**Agent verifies:**

```bash
# Test passes now
npm run test

# No linting errors
npm run lint

# TypeScript compiles
npm run build

# Related tests still pass
npm run test -- --related
```

### Step 6: Create Fix PR

**Branch:**
```
fix/form-submission-user-id-dependency
```

**PR Title:**
```
fix: add userId to useEffect dependencies in Form component
```

**PR Body:**
```
**Bug**: Form submission fails when user ID changes; uses stale data

**Root Cause**: useEffect hook was missing userId in dependency array, 
so effect didn't re-run when userId changed.

**Solution**: Added userId to useEffect dependencies

**Testing**: 
- Added test case that reproduces the bug
- Test now passes after fix
- All existing tests still pass
- No linting errors

**Verification Steps**:
1. Change user ID in form
2. Verify form data updates correctly
3. Submit form and confirm it sends the right data
```

---

## Common Bug Types & How to Fix

### 1. Stale Closures

**Symptom**: Handler uses old state value

**Example:**
```tsx
// WRONG
const [count, setCount] = useState(0);
const handleClick = () => {
  console.log(count);  // Always logs 0!
};

// RIGHT - Use useCallback with dependencies
const handleClick = useCallback(() => {
  console.log(count);
}, [count]);
```

### 2. Missing Dependencies

**Symptom**: Effect doesn't run when it should

**Example:**
```tsx
// WRONG
useEffect(() => {
  fetchData(id);
}, []);  // Runs once, never again!

// RIGHT
useEffect(() => {
  fetchData(id);
}, [id]);  // Runs when id changes
```

### 3. Async Race Conditions

**Symptom**: Old data appears after new data is fetched

**Example:**
```tsx
// WRONG - old response can overwrite new one
useEffect(() => {
  fetchData(id).then(setData);
}, [id]);

// RIGHT - ignore outdated responses
useEffect(() => {
  let isMounted = true;
  fetchData(id).then(data => {
    if (isMounted) setData(data);
  });
  return () => { isMounted = false; };
}, [id]);
```

### 4. Type Errors

**Symptom**: Runtime error "Cannot read property X of undefined"

**Example:**
```tsx
// WRONG - No type checking
const user = response.data;
console.log(user.email);  // Crashes if data is undefined

// RIGHT - Type guard
if (response.data && response.data.email) {
  console.log(response.data.email);
}

// Or better: proper TypeScript
interface User {
  email: string;
}
const user = response.data as User;
if (!user?.email) return <Error />;
console.log(user.email);
```

### 5. Key Prop Issues

**Symptom**: Wrong data in list items, state gets jumbled

**Example:**
```tsx
// WRONG - using index as key
{items.map((item, index) => (
  <Item key={index} data={item} />
))}

// RIGHT - use unique identifier
{items.map(item => (
  <Item key={item.id} data={item} />
))}
```

### 6. Event Listener Leaks

**Symptom**: Memory leaks, listeners called multiple times

**Example:**
```tsx
// WRONG - listener added but never removed
useEffect(() => {
  window.addEventListener('resize', handleResize);
}, []);

// RIGHT - cleanup function removes listener
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => {
    window.removeEventListener('resize', handleResize);
  };
}, []);
```

### 7. Conditional Hooks

**Symptom**: "Hooks called out of order" error

**Example:**
```tsx
// WRONG - hook called conditionally
if (shouldUseSomething) {
  useState(0);  // ERROR!
}

// RIGHT - hooks always called at top level
const [value] = useState(0);
if (shouldUseValue) {
  // Use the value
}
```

### 8. Incorrect Conditional Rendering

**Symptom**: Component shows/hides incorrectly

**Example:**
```tsx
// WRONG - loading state logic
if (isLoading) return <Loading />;
if (data) return <Data />;  // Shows even while loading!

// RIGHT - be explicit about states
if (isLoading) return <Loading />;
if (!data) return <Error />;
return <Data data={data} />;
```

---

## Debugging Techniques

### Using Console Logs

```tsx
function UserProfile({ userId }) {
  console.log('UserProfile rendered with userId:', userId);
  
  useEffect(() => {
    console.log('Effect running, fetching user:', userId);
    fetchUser(userId).then(user => {
      console.log('Fetched user:', user);
      setUser(user);
    });
  }, [userId]);

  return <div>{user?.name}</div>;
}
```

### Using React DevTools

1. Install React DevTools browser extension
2. Open Developer Tools (F12)
3. Go to React tab
4. Inspect components:
   - View props and state
   - Trigger re-renders
   - Check which components re-render
5. Use Profiler to find performance issues

### Using Browser DevTools

1. **Console tab**:
   - Check for JavaScript errors
   - View logs
   - Run commands in console

2. **Network tab**:
   - Check API calls
   - See response data
   - Check for failed requests

3. **Elements/Inspector tab**:
   - Check HTML structure
   - Verify CSS is applied
   - Check data attributes

4. **Sources tab**:
   - Set breakpoints
   - Step through code
   - Watch variables

---

## Testing Bug Fixes

Always write a test that reproduces the bug BEFORE fixing it:

```tsx
describe('UserProfile', () => {
  // This test demonstrates the bug
  test('should fetch new data when userId prop changes', async () => {
    const { rerender } = render(<UserProfile userId="1" />);
    
    // Initial fetch
    await waitFor(() => {
      expect(screen.getByText(/Alice/i)).toBeInTheDocument();
    });

    // BUG: Changing userId doesn't fetch new data
    rerender(<UserProfile userId="2" />);

    // This assertion fails with the bug, passes after fix
    await waitFor(() => {
      expect(screen.getByText(/Bob/i)).toBeInTheDocument();
    });
  });
});
```

---

## How to Ask the Agent to Fix Bugs

### Good Bug Reports

**Clear & Detailed:**
```
"When I click the 'Submit' button on the contact form, nothing happens.
Console shows: 'TypeError: Cannot read property email of undefined'
The form has email, name, and message fields.
This started after the last commit."
```

**With Reproduction Steps:**
```
1. Go to /contact page
2. Enter name and email but leave message blank
3. Click Submit
4. See error in console
```

### Let the Agent Ask Questions

Be ready to answer:
- "Can you show me the error message?"
- "When did this start happening?"
- "Is it every time or intermittent?"
- "What browser/device are you using?"

### The Agent Will

1. Read your code
2. Ask clarifying questions if needed
3. Write a failing test
4. Fix the bug
5. Verify with tests
6. Open a PR for review

---

## Bug Fix Commands

```bash
# Run tests with watch mode (best for debugging)
npm run test -- --watch

# Run specific test file
npm run test -- UserProfile.test.tsx

# Run tests for modified files
npm run test -- --onlyChanged

# Check coverage to find untested code
npm run test -- --coverage

# Check for type errors
npm run type-check

# Lint and fix issues
npm run lint -- --fix

# Verify build works
npm run build

# For React Native: reset bundler cache
npm start -- --reset-cache
```

---

## Tips for the Agent

### Good Bug Fixing Practices

✅ **Do:**
- Ask for reproduction steps
- Write failing test first
- Make minimal code changes
- Run all quality checks before PR
- Explain root cause in PR description
- Reference the GitHub issue if there is one

❌ **Don't:**
- Refactor unrelated code
- Skip tests
- Assume root cause without investigation
- Push directly to main
- Change multiple files for single bug
- Ignore lint errors

### Mindset

**Bugs are learning opportunities:**
- Take time to understand WHY the bug happened
- Document common patterns in MEMORY.md
- Update SYSTEM_PROMPT.md if new pattern emerges
- Help prevent similar bugs in future

---

## Success Criteria

A bug fix is complete when:

- ✅ Bug is reproduced and understood
- ✅ Test written that demonstrates bug (fails first)
- ✅ Code fixed with minimal changes
- ✅ All tests pass
- ✅ No linting errors
- ✅ TypeScript compiles without errors
- ✅ PR created with clear description
- ✅ Root cause explained in PR body

---

## Resources

**React Hooks Best Practices:**
- https://react.dev/reference/rules/rules-of-hooks
- https://react.dev/learn/lifecycle-of-reactive-effect

**TypeScript Patterns:**
- https://www.typescriptlang.org/docs/handbook/
- https://www.typescriptlang.org/docs/handbook/2/narrowing.html

**Testing Best Practices:**
- https://testing-library.com/docs/queries/about
- https://kentcdodds.com/blog/common-mistakes-with-react-testing-library

---

**Your agent is ready to help you find and fix bugs!** When you encounter an issue, describe it clearly and the agent will work through it systematically.
