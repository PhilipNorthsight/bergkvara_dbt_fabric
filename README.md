Welcome to your new dbt project!


### Using your local profiles.yml

To use the `profiles.yml` in this project folder instead of the default dbt location, set the environment variable before running dbt commands in PowerShell:

```powershell
$env:DBT_PROFILES_DIR = "C:\Users\philip.lind\Documents\Projects\bergkvara_dbt_fabric"
```

Then run dbt as usual:

```powershell
dbt run
dbt test
```


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
