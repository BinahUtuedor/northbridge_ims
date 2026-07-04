{% macro cast_boolean(field) %}

case
    when lower(trim(cast({{ field }} as string))) in ('1','1.0','true','t','yes','y') then true
    when lower(trim(cast({{ field }} as string))) in ('0','0.0','false','f','no','n') then false
    else null
end

{% endmacro %}