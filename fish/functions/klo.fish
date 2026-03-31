function klo --wraps='kubectl logs -f' --description 'alias klo=kubectl logs -f'
  kubectl logs -f $argv
        
end
