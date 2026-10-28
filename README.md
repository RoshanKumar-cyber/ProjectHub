# ProjectHub — Project Publishing Studio

ProjectHub is a React + TypeScript project dashboard now wired to Supabase for email/password authentication and PostgreSQL project storage.

## Run locally

Requirements: Node.js 20+ and npm.

1. Ensure `.env.local` contains your Supabase project URL and **publishable** key. The publishable key is designed for frontend use; never put a secret/service-role key in frontend environment variables.
2. Install dependencies and start the app:

```bash
npm install
npm run dev
```

3. Open the local URL printed by Vite.

## Configure the Supabase database

1. Open your Supabase project and go to **SQL Editor**.
2. Create a new query, paste the contents of `supabase/setup.sql`, and run it.
3. In **Authentication**, create your administrator user with your own email and a strong password.
4. In **Authentication settings / Providers**, disable public email sign-ups. Only the administrator account should be able to sign in to the dashboard.
5. Sign in to ProjectHub with that administrator account.

The app does not automatically seed demo data into the database. Create projects in the dashboard after the schema is installed.

## Environment variables

Local `.env.local`:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_your_publishable_key
```

When deploying, add the same two variables in your hosting provider's environment settings and redeploy. Do not add database passwords, secret keys, or service-role keys to `VITE_*` variables.

## Build

```bash
npm run build
npm run preview
```

The production static files are generated in `dist/`.

## Deploy frontend on Render

1. Push the project folder to a GitHub repository.
2. In Render, create a **Static Site** connected to that repository.
3. Build command: `npm install && npm run build`
4. Publish directory: `dist`
5. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` under the site's environment variables.
6. Deploy.

## Security notes

- `supabase/setup.sql` enables Row Level Security. Anonymous visitors can select only published projects; authenticated users can manage project rows.
- Disable public sign-ups and create only the administrator account. If you later allow other users, replace the broad authenticated policy with an explicit admin-role check.
- The public preview can be opened with `?view=public`. Keep the publishable key public-safe and rely on RLS for data access.
- Cloud image uploads, GitHub repository import, and analytics are not implemented yet.
