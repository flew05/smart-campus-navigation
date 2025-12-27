# Next Steps

## 1. Push to GitHub (2 min)

If not done yet, create GitHub repository and push:

```bash
git remote add origin https://github.com/YOUR_USERNAME/smart-campus-navigation.git
git branch -M main
git push -u origin main
```

**Note:** If remote already exists, just push:
```bash
git push
```

## 2. Create Jenkins Pipeline (5 min)

1. Open Jenkins: http://54.237.222.37:8080
2. Login: `admin` / Password: `jGntpecvcs6wQxS1`
3. **New Item**
4. Name: `ExampleProjectPipeline` ⚠️ **Exact name!**
5. Type: **Pipeline** → OK
6. Configure:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: your GitHub repo URL
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
7. **Save**
8. **Build Now**

## 3. Monitor Build

1. Click on build #1
2. Click **Console Output**
3. Watch progress through 9 stages:
   - Checkout
   - Build
   - Unit Tests
   - SonarQube Analysis
   - Quality Gate
   - Package
   - Deploy to Nexus
   - Deploy Application
   - Health Check

## 4. Verify Deployment

After successful build:

```bash
curl http://54.237.222.37:8888/actuator/health
```

Expected: `{"status":"UP"}`

## 5. Check Verification

Run verification again - all tests should pass ✅

---

## Credentials Reference

See `CREDENTIALS.md` for all deployment credentials.

## Troubleshooting

- **Build fails**: Check Console Output for errors
- **Nexus connection fails**: Verify credentials in `Jenkinsfile`
- **SonarQube fails**: Check `sonar-project.properties`
- **App doesn't start**: Check port 8888 is available

---

**Good luck!** 🚀

