from app.config import PROJECT_ID
import snoop

@snoop
def main() -> str:
    project_id = PROJECT_ID
    return project_id


if __name__ == "__main__":
    main()
