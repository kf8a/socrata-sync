This is a application written in Elixir to retrieve data from a Campbell Scientific Loggernet installation using cora_script and sending the data to a database. It uses Oban to schedule data retrieval jobs.

## Project guidelines

- When working on a new feature, first write tests for the feature, ask for approval, then write the code to pass the tests. Don't write the code until you have the tests approved.
- Use `mix precommit` alias when you are done with all changes and fix any pending issues
- Use the included and available `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`.

### Module design and complexity

**IMPORTANT**: When working with modules that are becoming too large or complex:

- **Monitor module size and complexity**: If a module exceeds ~500-600 lines or contains deeply nested logic with high cyclomatic complexity, consider refactoring
- **Break out logical concerns**: Extract related functionality into separate, focused modules that handle a single responsibility
- **Use helper modules**: For complex domains (like task management), consider creating dedicated modules for specific sub-concerns:
  - Positioning logic (e.g., `Tasks.Positioning`)
  - Dependency management (e.g., `Tasks.Dependencies`)
  - Validation logic (e.g., `Tasks.Validation`)
  - Query builders (e.g., `Tasks.Queries`)
- **Extract helper functions**: When a function becomes complex (cyclomatic complexity > 9), extract complex conditional logic into smaller, well-named helper functions
- **Maintain clear module boundaries**: Each module should have a clear, single purpose with a well-defined public API
- **Document module organization**: When splitting modules, update documentation to explain the new structure and how modules relate to each other

This approach improves:

- Code maintainability and readability
- Test isolation and coverage
- Collaboration between developers
- Ability to reason about individual components
- Credo compliance and code quality metrics

<!-- phoenix:ecto-start -->

## Ecto Guidelines

- Remember `import Ecto.Query` and other supporting modules when you write `seeds.exs`
- `Ecto.Schema` fields always use the `:string` type, even for `:text`, columns, ie: `field :name, :string`
- `Ecto.Changeset.validate_number/2` **DOES NOT SUPPORT the `:allow_nil` option**. By default, Ecto validations only run if a change for the given field exists and the change value is not nil, so such as option is never needed
- You **must** use `Ecto.Changeset.get_field(changeset, :field)` to access changeset fields
- Fields which are set programatically, such as `user_id`, must not be listed in `cast` calls or similar for security purposes. Instead they must be explicitly set when creating the struct

<!-- phoenix:ecto-end -->
<!-- usage-rules-end -->
