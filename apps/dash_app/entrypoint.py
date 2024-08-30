import os
from typing import Dict, Any
from gunicorn.app.base import BaseApplication

# Importing the Dash app
from app import server as application

class StandaloneApplication(BaseApplication):
    """
    A standalone application to run a Dash app with Gunicorn. This 
    class is designed to configure and run a Dash application using 
    the Gunicorn WSGI HTTP server.

    Attributes
    ----------
    application : Any
        The Dash application instance to be served by Gunicorn.
    options : Dict[str, Any], optional
        A dictionary of configuration options for Gunicorn.
    """
    def __init__(self, app: Any, options: Dict[str, Any] = None) -> None:
        """
        Constructor for StandaloneApplication with a Dash app and options.

        Parameters
        ----------
        app : Any
            The Dash application instance to serve.
        options : Dict[str, Any], optional
            A dictionary of Gunicorn configuration options.
        """
        self.options = options or {}
        self.application = app
        super(StandaloneApplication, self).__init__()

    def load_config(self):
        """
        Load the configuration from the provided options. This method 
        extracts the relevant options from the provided dictionary and 
        sets them for the Gunicorn server.
        """
        config = {key: value for key, value in self.options.items() 
                  if key in self.cfg.settings and value is not None}
        for key, value in config.items():
            self.cfg.set(key.lower(), value)

    def load(self) -> Any:
        """
        Return the application to be served by Gunicorn. This method is 
        required by Gunicorn and is called to get the application instance.

        Returns
        -------
        Any
            The Dash application instance to be served.
        """
        return self.application
      
def main() -> int:
  
    # Retrieve the SHINYPROXY_PUBLIC_PATH from environment variable
    public_path = os.environ['SHINYPROXY_PUBLIC_PATH']

    options = {
        'bind': '0.0.0.0:8050',
        'workers': 4, 
        'env': {'SHINYPROXY_PUBLIC_PATH': public_path},
    }

    StandaloneApplication(application, options).run()
    
    return 0
    
if __name__ == '__main__':

    main()
