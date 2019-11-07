from custom_sso_security_manager import CustomSsoSecurityManager
CUSTOM_SECURITY_MANAGER = CustomSsoSecurityManager

from flask_appbuilder.security.manager import AUTH_OID, AUTH_REMOTE_USER, AUTH_DB, AUTH_LDAP, AUTH_OAUTH
#basedir = os.path.abspath(os.path.dirname(__file__))

AUTH_TYPE = AUTH_OAUTH
OAUTH_PROVIDERS = [
    {
        'name': 'google',
        'icon': 'fa-google',
        'token_key': 'access_token',
        'remote_app': {
            'base_url': 'https://www.googleapis.com/oauth2/v2/',
            'request_token_params': {
                'scope': 'https://www.googleapis.com/auth/userinfo.email'
            },
            'request_token_url': None,
            'access_token_url': 'https://accounts.google.com/o/oauth2/token',
            'authorize_url': 'https://accounts.google.com/o/oauth2/auth',
            'consumer_key': '286651129249-obffnu29vm5b575nl202gkln5vvam7is.apps.googleusercontent.com',
            'consumer_secret': '6vrb6ZnPoQbkinarNzmHJJ8t'
        }
    }
]
# Will allow user self registration, allowing to create Flask users from Authorized User
AUTH_USER_REGISTRATION = True

# The default user self registration role
AUTH_USER_REGISTRATION_ROLE = "Public"
