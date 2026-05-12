import kagglehub
import os
import shutil

from tenacity import retry, wait_exponential, stop_after_attempt, retry_if_exception_type

from kagglehub.exceptions import UnauthenticatedError, CredentialError, KaggleApiHTTPError, BackendError

from dotenv import load_dotenv

load_dotenv()


def get_root_path():

    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def get_data_path():

    path = os.path.join(get_root_path(), "data")
    os.makedirs(path, exist_ok=True)
    return path


def delete_existing_files():

    data_path = get_data_path()
    shutil.rmtree(data_path)


def check_if_files_already_exist():

    data_path = get_data_path()
    with os.scandir(data_path) as it:
        return any(it)


def set_kaggle_credentials(api_key: str):
    root = get_root_path()

    file_path = os.path.join(root, ".env")
    if os.path.exists(file_path):
        os.remove(file_path)

    with open(file_path, "w") as f:
        f.write(f"\nKAGGLE_API_TOKEN={api_key}\n")

    os.environ['KAGGLE_API_TOKEN'] = api_key
    load_dotenv()


@retry(
    wait=wait_exponential(multiplier=1, min=4, max=10),
    stop=stop_after_attempt(5),
    retry=retry_if_exception_type(
        (UnauthenticatedError, CredentialError, KaggleApiHTTPError, BackendError)
    ),
)
def get_dataset():

    try:
        path = kagglehub.dataset_download(
            "puneet6060/intel-image-classification",
            output_dir=get_data_path()
            )

        print(f"Dataset downloaded to: {path}")

    except (UnauthenticatedError, CredentialError) as e:
        print(f"Failed to download dataset due to credentials error: {e}")
        print("Please ensure you have set up your Kaggle API credentials correctly.")
        api_key = input("Press Enter after setting up your credentials to retry...")
        set_kaggle_credentials(api_key)
        raise e

    except (KaggleApiHTTPError, BackendError) as e:
        print(f"Failed to download dataset due to API error: {e}")
        print("This might be a temporary issue with the Kaggle API. Retrying...")
        raise e

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        raise e



def main(force_download=False):

    if check_if_files_already_exist() and not force_download:
        print("Dataset already exists and is not empty. Skipping download.")
        return

    delete_existing_files()
    get_dataset()


if __name__ == "__main__":
    pass
