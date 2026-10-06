# CourseCraft

CourseCraft is an Online Course Management System for a college setting. Administrators manage courses and approve faculty, faculty run their courses (materials, assignments, attendance, grading, announcements), and students browse, enrol, submit work and track their grades.

**Live demo:** https://coursecraft-e8cf.onrender.com

The demo runs on a free hosting tier. If nobody has visited for a while, the first page load can take up to a minute while the server wakes up.

## Demo accounts

The live site and the seed data use these accounts.

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@coursecraft.edu | admin123 |
| Faculty | meera.iyer@coursecraft.edu | faculty123 |
| Faculty | rahul.deshmukh@coursecraft.edu | faculty123 |
| Faculty (pending approval) | imran.shaikh@coursecraft.edu | faculty123 |
| Student | ananya.gupta@coursecraft.edu | student123 |
| Student | karan.mehta@coursecraft.edu | student123 |

More student accounts (sneha.patil, rohit.verma, vikram.singh at coursecraft.edu) use `student123`. The pending faculty account cannot sign in until an admin approves it. Faculty who register through the public form also start in the pending state.

## What it does

**Admin**
- Add and manage courses, students and faculty
- Approve or reject faculty registrations
- Manage enrolments and post announcements
- View reports and platform statistics

**Faculty**
- Course workspace with materials, assignments and announcements
- Mark attendance per session
- Review submissions and enter grades

**Student**
- Browse the course catalogue and enrol
- View course materials and announcements
- Submit assignments and see grades
- Check attendance

## Tech stack

- Java 17, Servlets and JSP with JSTL (Jakarta EE, Tomcat 10.1)
- JDBC with HikariCP connection pooling
- MySQL 8
- BCrypt (jBCrypt) for password hashing, CSRF tokens on all POST forms
- Bootstrap 5 with a custom stylesheet
- Maven for the build, Docker for deployment

## Project layout

```
src/main/java/com/ocms/
  controller/   servlets
  dao/          database access
  model/        data classes
  filter/       authentication, CSRF and cookie filters
  util/         DB connection, password and paging helpers
src/main/webapp/   JSP views and static assets
db/                schema, UI enhancements and seed data
Dockerfile         multi-stage build (Maven, then Tomcat)
```

## Run locally

Requirements: JDK 17 or newer, Maven 3.9+, MySQL 8, Tomcat 10.1.

1. Load the database. In a terminal, open the MySQL client and run the three scripts in order:

   ```sql
   source db/01_schema.sql
   source db/02_ui_enhancements.sql
   source db/03_seed_data.sql
   ```

2. Build the WAR:

   ```bash
   mvn clean package
   ```

3. Set the database password for the app (see the table below), then copy `target/ROOT.war` into Tomcat's `webapps` folder and start Tomcat.

4. Open http://localhost:8080/. The health check at `/health` returns `OK` when the database is reachable.

### Configuration

The app reads its database settings from environment variables.

| Variable | Default | Purpose |
|----------|---------|---------|
| `DB_URL` | `jdbc:mysql://localhost:3306/course_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC` | JDBC connection URL |
| `DB_USER` | `root` | Database user |
| `DB_PASSWORD` | `root` | Database password |
| `UPLOAD_DIR` | `~/coursecraft_uploads` | Where uploaded files are stored |

## Docker

```bash
docker build -t coursecraft .
docker run -p 8080:8080 \
  -e DB_URL="jdbc:mysql://host.docker.internal:3306/course_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC" \
  -e DB_USER=root \
  -e DB_PASSWORD=yourpassword \
  coursecraft
```

Load the SQL scripts into MySQL before starting the container.

## Deployment

The live demo uses:

- **Render** (free web service, built from the Dockerfile) for the application
- **Aiven** (free MySQL) for the database

Environment variables set on Render: `DB_URL` (with `sslMode=REQUIRED`, which Aiven requires), `DB_USER`, `DB_PASSWORD` and `PORT=8080`.

## Known limitations

- Uploaded files are stored on the server's disk. On the free hosting tier the disk is temporary, so uploads can disappear when the service restarts. A persistent disk or object storage would be needed for real use.
- The free tier sleeps after a period of inactivity, so the first request after a break is slow.
- The demo accounts and their passwords are public. Do not reuse them anywhere else.

## Author

Abhishek Yadav, CSE (AIML). Built as a college mini project.
