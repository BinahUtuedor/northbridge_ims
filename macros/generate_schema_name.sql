{% macro generate_schema_name(custom_schema_name, node) %}

    {# ------------------------------------------------------------
       If no custom schema is defined, use the default schema
       ------------------------------------------------------------ #}
    {% set default_schema = target.schema %}

    {# ------------------------------------------------------------
       If model has a schema defined in dbt_project.yml, use it directly
       WITHOUT appending the target schema
       ------------------------------------------------------------ #}

    {% if custom_schema_name is none %}
        {{ default_schema }}

    {% else %}
        {{ custom_schema_name }}

    {% endif %}

{% endmacro %}