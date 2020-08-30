#http://patorjk.com/software/taag/#p=display&f=Slant&t=Symfony%20%203.4
cat <<'MSG'

    ____  __  ______     ______ _____    ___        __  ___           _       ____  ____ 
   / __ \/ / / / __ \   / ____// ___/   ( _ )      /  |/  /___ ______(_)___ _/ __ \/ __ )
  / /_/ / /_/ / /_/ /  /___ \ / __ \   / __ \/|   / /|_/ / __ `/ ___/ / __ `/ / / / __  |
 / ____/ __  / ____/  ____/ // /_/ /  / /_/  <   / /  / / /_/ / /  / / /_/ / /_/ / /_/ / 
/_/   /_/ /_/_/      /_____(_)____/   \____/\/  /_/  /_/\__,_/_/  /_/\__,_/_____/_____/  

MSG

echo "PHP version: ${PHP_VERSION}"


symfony() {
	composer.phar create-project symfony/framework-standard-edition --no-interaction . "3.4.*"
}

